Temporada de pases en mutualistas
=========

### Para correr en desarrollo:

```
bundle install
bundle exec shotgun -p 9393
```

### Para hacer un custom build de bootstrap:

```
cd public/
lessc less/bootstrap.less > stylesheets/bootstrap.custom.css
```

### Para concatenar y minificar estilos:

```
cd public/stylesheets/
uglifycss bootstrap.custom.css data-style.css > styles.css
```

### Para concatenar y minificar scripts:

```
cd public/javascripts/
uglifyjs jquery.js transition.js carousel.js tooltip.js webapp.js -o code.js
```

### Dependencias de entorno

* [Bundler](http://bundler.io/)
* [Less](http://lesscss.org/)
* [UglifyCSS](https://www.npmjs.org/package/uglifycss/)
* [UglifyJS](https://www.npmjs.org/package/uglify-js/)