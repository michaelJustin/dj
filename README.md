
# Daraja Framework

Daraja is a flexible HTTP server framework for Object Pascal, based on the stand-alone HTTP server in the free open source library Internet Direct (Indy).

Daraja provides the core foundation for serving HTTP resources of all content-types such as HTML pages, images, scripts, web service responses etc. by mapping resource paths to your own code. Your code then can create the response content, or let the framework serve a static file. 

## Optional Extensions

### daraja-restful

A RESTful framework extension, version 1.0 is compatible with Delphi 2009 and newer. Version 2.0 introduces support for Free Pascal, using a slightly different configuration of RESTful resource handlers.

https://github.com/michaelJustin/daraja-restful

### slf4p

A simple logging facade with support for LazLogger, Log4D, and other logging frameworks.

https://github.com/michaelJustin/slf4p

You can find this project at https://github.com/michaelJustin/daraja-framework

## Documentation

### Getting Started PDF

A Getting Started document (PDF) is available at https://www.habarisoft.com/daraja_framework/1.1/docs/DarajaFrameworkGettingStarted.pdf

### Project home page

Visit https://www.habarisoft.com/daraja_framework.html for more information.

## IDE configuration

### Required paths

* The project search path must include the Indy and Daraja source directories.

Example:

`<daraja-home>\source;<indy-home>\Lib\Core\;<indy-home>\Lib\Protocols\;<indy-home>\Lib\System\`

* The project search path for Include files must include the Indy Core path.

Example:

`<indy-home>\Lib\Core\`

### Optional source

Some useful (but optional) units are located in the `optional` subfolder. Include it when needed:

`<daraja-home>\source;<daraja-home>\source\optional;<indy-home>\Lib\Core\;<indy-home>\Lib\Protocols\;<indy-home>\Lib\System\`
