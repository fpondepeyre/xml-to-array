<?php

declare(strict_types=1);

namespace fpondepeyre\XmlToArray;

class XmlToArray
{
    public static function convert(string $xml): array
    {
        assert(\class_exists('\DOMDocument'));
        $doc = new \DOMDocument();
        $doc->loadXML($xml);
        $root = $doc->documentElement;
        $output = (array) Helper::domNodeToArray($root);

        $output['@root'] = $root->tagName;

        return $output ?? [];
    }
}
