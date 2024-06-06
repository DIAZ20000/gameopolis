from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_mysqldb import MySQL
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename
import os

app = Flask(__name__)
app.secret_key = 'supersecretkey'  # Necesario para usar flash messages

# Configuración para subir archivos
UPLOAD_FOLDER = 'static/imagen'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Configuración de la base de datos MySQL
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'pma'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'Gameopolis1'

mysql = MySQL(app)


# Función para verificar la extensión del archivo
def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


# Función de autenticación
@app.route('/loggin', methods=['GET', 'POST'])
def loggin():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM usuarios WHERE nombre_usuario = %s", (username,))
        user = cursor.fetchone()
        cursor.close()

        if user and check_password_hash(user[2], password):  # Utilizar check_password_hash
            session['user_id'] = user[0]
            session['username'] = user[1]
            return redirect(url_for('home_sistema'))
        else:
            flash('Usuario o contraseña incorrectos')
            return render_template('loggin.html', error=True)

    return render_template('loggin.html')
@app.route('/logout')
def logout():
    session.pop('user_id', None)
    session.pop('username', None)
    return redirect(url_for('loggin'))


@app.route('/home_sistema')
def home_sistema():
    return render_template('home_sistema.html')

# Función para agregar usuarios a la base de datos
def agregar_usuario_db(nombre_usuario, contrasena):
    try:
        cursor = mysql.connection.cursor()
        # Verificar si el usuario ya existe
        cursor.execute("SELECT * FROM usuarios WHERE nombre_usuario = %s", (nombre_usuario,))
        existing_user = cursor.fetchone()
        if existing_user:
            return False  # Usuario ya existe
        else:
            hashed_password = generate_password_hash(contrasena)  # Hash de la contraseña
            cursor.execute("INSERT INTO usuarios (nombre_usuario, contrasena) VALUES (%s, %s)",
                           (nombre_usuario, hashed_password))
            mysql.connection.commit()
            cursor.close()
            return True  # Usuario agregado correctamente
    except Exception as e:
        print(f'Error al agregar usuario: {e}')
        return False  # Error al agregar usuario


# Ruta para agregar usuarios
@app.route('/agregar_usuario', methods=['GET', 'POST'])
def agregar_usuario():
    if request.method == 'POST':
        nombre_usuario = request.form['nombre_usuario']
        contrasena = request.form['contrasena']

        if agregar_usuario_db(nombre_usuario, contrasena):
            flash('Usuario agregado correctamente')
            return redirect(url_for('agregar_usuario'))
        else:
            flash('Este usuario ya existe o ha ocurrido un error al agregarlo')
            return redirect(url_for('agregar_usuario'))

    return render_template('agregar_usuario.html')
# Definir la ruta para agregar una nueva plataforma
@app.route('/agregar_plataforma', methods=['GET', 'POST'])
def agregar_plataforma():
    if request.method == 'POST':
        nombre = request.form['nombre']

        # Guardar la imagen en el servidor
        if 'imagen' not in request.files:
            flash('No se seleccionó ningún archivo de imagen')
            return redirect(request.url)

        imagen = request.files['imagen']
        if imagen.filename == '':
            flash('No se seleccionó ningún archivo de imagen')
            return redirect(request.url)

        if imagen and allowed_file(imagen.filename):
            filename = secure_filename(imagen.filename)
            ruta_imagen = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            imagen.save(ruta_imagen)
        else:
            flash('Formato de imagen no permitido')
            return redirect(request.url)

        # Insertar los datos en la base de datos
        try:
            cursor = mysql.connection.cursor()
            cursor.execute("INSERT INTO Plataforma (nombre, imagen) VALUES (%s, %s)", (nombre, ruta_imagen))
            mysql.connection.commit()
            cursor.close()
            flash('Plataforma agregada exitosamente')
        except Exception as e:
            flash(f'Error al guardar plataforma: {e}')
            return redirect(request.url)

        # Después de agregar la plataforma, redirigir a la misma página para mostrar la tabla actualizada
        return redirect(url_for('agregar_plataforma'))

    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM Plataforma")
    plataformas = cursor.fetchall()
    cursor.close()

    return render_template('agregar_plataforma.html', plataformas=plataformas)


@app.route('/eliminar_plataforma/<int:id>', methods=['POST'])
def eliminar_plataforma(id):
    try:
        cursor = mysql.connection.cursor()

        # Primero, eliminar los videojuegos asociados a la plataforma
        cursor.execute("DELETE FROM Videojuegos WHERE plataforma_id = %s", (id,))
        mysql.connection.commit()

        # Luego, eliminar la plataforma
        cursor.execute("DELETE FROM Plataforma WHERE plataforma_id = %s", (id,))
        mysql.connection.commit()

        cursor.close()
        flash('Plataforma eliminada exitosamente')
    except Exception as e:
        flash(f'Error al eliminar plataforma: {e}')
    return redirect(url_for('agregar_plataforma'))


@app.route('/editar_plataforma/<int:id>', methods=['GET', 'POST'])
def editar_plataforma(id):
    cursor = mysql.connection.cursor()
    if request.method == 'POST':
        nombre = request.form['nombre']

        if 'imagen' in request.files and request.files['imagen'].filename != '':
            imagen = request.files['imagen']
            if imagen and allowed_file(imagen.filename):
                filename = secure_filename(imagen.filename)
                ruta_imagen = os.path.join(app.config['UPLOAD_FOLDER'], filename)
                imagen.save(ruta_imagen)
                cursor.execute("UPDATE Plataforma SET nombre = %s, imagen = %s WHERE plataforma_id = %s",
                               (nombre, ruta_imagen, id))
            else:
                flash('Formato de imagen no permitido')
                return redirect(request.url)
        else:
            cursor.execute("UPDATE Plataforma SET nombre = %s WHERE plataforma_id = %s", (nombre, id))

        mysql.connection.commit()
        cursor.close()
        flash('Plataforma actualizada exitosamente')
        return redirect(url_for('agregar_plataforma'))

    cursor.execute("SELECT * FROM Plataforma WHERE plataforma_id = %s", (id,))
    plataforma = cursor.fetchone()
    cursor.close()
    if plataforma:
        return render_template('editar_plataforma.html', plataforma=plataforma)
    else:
        flash('No se encontró la plataforma')
        return redirect(url_for('agregar_plataforma'))

@app.route('/contacto')
def contacto():
    return render_template('contacto.html')

@app.route('/mostrar_imagenes_videojuegos', methods=['GET'])
def mostrar_imagenes_videojuegos():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT imagen, nombre, precio FROM Videojuegos ORDER BY nombre")
    videojuegos = cursor.fetchall()
    cursor.close()
    return render_template('mostrar_imagenes.html', juegos=videojuegos)


# Definir las rutas para las páginas
@app.route('/', methods=['GET'])
def home():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM Videojuegos")
    videojuegos = cursor.fetchall()
    cursor.close()

    return render_template('index.html', videojuegos=videojuegos)


@app.route('/agregar_videojuego', methods=['GET'])
def agregar_videojuego():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT videojuego_id, nombre, precio, plataforma_id, stock, imagen FROM Videojuegos")
    videojuegos = cursor.fetchall()
    cursor.execute("SELECT plataforma_id, nombre FROM Plataforma")
    plataformas = cursor.fetchall()
    cursor.close()
    return render_template('agregar_videojuego.html', videojuegos=videojuegos, plataformas=plataformas)


@app.route('/guardar_videojuego', methods=['POST'])
def guardar_videojuego():
    nombre = request.form['nombre']
    precio = request.form['precio']
    plataforma = request.form['plataforma']
    stock = request.form['stock']

    if float(precio) < 0 or int(stock) < 0:
        flash('El precio y el stock no pueden ser negativos')
        return redirect(url_for('agregar_videojuego'))

    imagen = request.files['imagen']
    if imagen.filename == '':
        flash('No se seleccionó ningún archivo de imagen')
        return redirect(url_for('agregar_videojuego'))

    if imagen and allowed_file(imagen.filename):
        filename = secure_filename(imagen.filename)
        ruta_imagen = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        imagen.save(ruta_imagen)

        try:
            cursor = mysql.connection.cursor()
            cursor.execute(
                "INSERT INTO Videojuegos (nombre, precio, plataforma_id, stock, imagen) VALUES (%s, %s, %s, %s, %s)",
                (nombre, precio, plataforma, stock, ruta_imagen))
            mysql.connection.commit()
            cursor.close()
            flash('Videojuego agregado exitosamente')
        except Exception as e:
            flash(f'Error al guardar videojuego: {e}')
            return redirect(url_for('agregar_videojuego'))

        return redirect(url_for('agregar_videojuego'))
    else:
        flash('Error al guardar la imagen')
        return redirect(url_for('agregar_videojuego'))

@app.route('/mostrar_imagenes_plataformas')
def mostrar_imagenes_plataformas():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT plataforma_id, imagen, nombre FROM Plataforma")
    plataformas = cursor.fetchall()
    cursor.close()
    return render_template('mostrar_imagenes_plataformas.html', plataformas=plataformas)

@app.route('/plataforma/<int:plataforma_id>', methods=['GET'])
def juegos_por_plataforma(plataforma_id):
    cursor = mysql.connection.cursor()
    cursor.execute("""
        SELECT imagen, nombre, precio 
        FROM Videojuegos
        WHERE plataforma_id = %s
        ORDER BY nombre
    """, (plataforma_id,))
    videojuegos = cursor.fetchall()
    cursor.execute("SELECT nombre FROM Plataforma WHERE plataforma_id = %s", (plataforma_id,))
    plataforma = cursor.fetchone()
    cursor.close()
    return render_template('juegos_por_plataforma.html', videojuegos=videojuegos, plataforma=plataforma)


@app.route('/eliminar_videojuego/<int:id>', methods=['POST'])
def eliminar_videojuego(id):
    try:
        cursor = mysql.connection.cursor()
        cursor.execute("DELETE FROM Videojuegos WHERE videojuego_id = %s", (id,))
        mysql.connection.commit()
        cursor.close()
        flash('Videojuego eliminado exitosamente')
    except Exception as e:
        flash(f'Error al eliminar videojuego: {e}')
    return redirect(url_for('agregar_videojuego'))


@app.route('/editar_videojuego/<int:id>', methods=['GET'])
def editar_videojuego(id):
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM Videojuegos WHERE videojuego_id = %s", (id,))
    videojuego = cursor.fetchone()
    cursor.execute("SELECT * FROM Plataforma")
    plataformas = cursor.fetchall()
    cursor.close()
    if videojuego:
        return render_template('editar_videojuego.html', videojuego=videojuego, plataformas=plataformas)
    else:
        flash('No se encontró el videojuego')
        return redirect(url_for('agregar_videojuego'))


@app.route('/actualizar_videojuego/<int:id>', methods=['POST'])
def actualizar_videojuego(id):
    nombre = request.form['nombre']
    precio = request.form['precio']
    plataforma_id = request.form['plataforma_id']
    stock = request.form['stock']
    imagen = request.files['imagen']
    ruta_imagen = request.form['ruta_imagen_actual']  # Ruta actual de la imagen

    if imagen and allowed_file(imagen.filename):
        filename = secure_filename(imagen.filename)
        ruta_imagen = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        imagen.save(ruta_imagen)

    cursor = mysql.connection.cursor()
    cursor.execute("""
        UPDATE Videojuegos
        SET nombre = %s, precio = %s, plataforma_id = %s, stock = %s, imagen = %s
        WHERE videojuego_id = %s
    """, (nombre, precio, plataforma_id, stock, ruta_imagen, id))
    mysql.connection.commit()
    cursor.close()
    flash('Videojuego actualizado exitosamente')
    return redirect(url_for('agregar_videojuego'))


if __name__ == '__main__':
    app.run(debug=True)
