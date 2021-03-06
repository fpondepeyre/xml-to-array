Convert xml to an array
==========================

This package provides a very simple class to convert xml string to an array.
Copy of https://github.com/gaarf/XML-string-to-PHP-array with small change for work with spatie/array-to-xml package. (https://github.com/spatie/array-to-xml)

```php
use Spatie\ArrayToXml\ArrayToXml;
use fpondepeyre\XmlToArray\XmlToArray;
...
ArrayToXml::convert(XmlToArray::convert($xml));
```

Install and simply use
----------------------

Use Composer:

```shell
composer require fpondepeyre/xml-to-array
```

And then package will be automatically installed to your project and you can simply call:

```php
$result = XmlToArray::convert($xml);
```

Documentation
-------------

One common need when working in PHP is a way to convert an XML document
into a serializable array. If you ever tried to serialize() and then
unserialize() a SimpleXML or DOMDocument object, you know what I’m
talking about.

Assume the following XML snippet:

```xml
<tv>
	<show name="Family Guy">
		<dog>Brian</dog>
		<kid>Chris</kid>
		<kid>Meg</kid>
	</show>
</tv>
```

There’s a quick and dirty way to do convert such a document to an array,
using type casting and the JSON functions to ensure there are no exotic
values that would cause problems when unserializing:

```php
$a = json_decode(json_encode((array) XmlToArray::convert($s)), true);
```

Here is the result for our sample XML, eg if we `print_r($a)`:

```
Array
(
    [show] => Array
        (
            [_attributes] => Array
                (
                    [name] => Family Guy
                )
            [dog] => Brian
            [kid] => Array
                (
                    [0] => Chris
                    [1] => Meg
                )
        )
)
```

Pretty nifty, eh? But maybe we want to embed some HTML tags or something
crazy along those lines. then we need a CDATA node…

```xml
<tv>
	<show name="Family Guy">
		<dog>Brian</dog>
		<kid>Chris</kid>
		<kid>Meg</kid>
		<kid><![CDATA[<em>Stewie</em>]]></kid>
	</show>
</tv>
```

The snippet of XML above would yield the following:

```
Array
(
    [show] => Array
        (
            [_attributes] => Array
                (
                    [name] => Family Guy
                )
            [dog] => Brian
            [kid] => Array
                (
                    [0] => Chris
                    [1] => Meg
                    [2] => Array
                        (
                        )
                )
        )
)
```

That’s not very useful. We got in trouble because the CDATA node, a
SimpleXMLElement, is being cast to an array instead of a string. To
handle this case while still keeping the nice _attributes notation, we
need a slightly more verbose conversion function. This is my version,
hereby released under a do-whatever-but-dont-sue-me license.

The result, for our *Stewie* snippet:

```
Array
(
    [show] => Array
        (
            [_attributes] => Array
                (
                    [name] => Family Guy
                )
            [dog] => Brian
            [kid] => Array
                (
                    [0] => Chris
                    [1] => Meg
                    [2] => <em>Stewie</em>
                )
        )
)
```

Victory is mine! :D

---
