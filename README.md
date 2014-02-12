Temporada de pases en mutualistas
=========

Para correr en desarrollo:

```
bundle install
bundle exec shotgun -p 9393
```

Para concatenar y minificar scripts:

```
cd public/javascripts/
uglifyjs jquery.js transition.js carousel.js tooltip.js webapp.js -o code.js
```

### Dependencias de entorno

* [Bundler](http://bundler.io/)
* [UglifyJS](https://www.npmjs.org/package/uglify-js/)