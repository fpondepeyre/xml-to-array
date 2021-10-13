#!/usr/bin/env php
<?php

include __DIR__ . '/../src/XmlToArray.php';
include __DIR__ . '/../src/Helper.php';

function prettyPrint($title, $thing)
{
  echo "\n-- $title: ---------------------------------------------\n";
  print_r($thing);
  echo "\n";
}

$xmlstr = <<<EOD
  <tv type="cartoon">
    <show name="Family Guy">
      <dog>Brian</dog>
      <kid>Chris</kid>
      <kid>Meg</kid>
      <kid><![CDATA[<em>Stewie</em>]]></kid>
    </show>
    <show name="American Dad!">
      <pet type="fish">Klaus</pet>
      <alien nick="The Decider">
        <persona>Roger Smith</persona>
        <persona>Sidney Huffman</persona>
      </alien>
    </show>
    <show name="Edge Cases" zero="0" empty="">
      <empty></empty>
      <foo empty=""></foo>
      <zero>0</zero>
    </show>
  </tv>
EOD;

$expected = array(

  "@root" => 'tv',

  "_attributes" => array( "type" => "cartoon" ),

  "show" => array(

    array(
      "dog" => 'Brian',
      "kid" => array(
        "Chris",
        "Meg",
        "<em>Stewie</em>"
      ),
      "_attributes" => array( "name" => "Family Guy" )
    ),

    array(
      'pet' => array(
        "_value" => 'Klaus',
        "_attributes" => array( "type" => "fish" )
      ),
      'alien' => array(
        'persona' => array(
          'Roger Smith',
          'Sidney Huffman'
        ),
        "_attributes" => array( "nick" => "The Decider" )
      ),
      "_attributes" => array( "name" => "American Dad!" )
    ),

    array(
      "empty" => array(),
      "foo" => array(
        "_attributes" => array(
          "empty" => ""
        )
      ),
      "zero" => "0",
      "_attributes" => array(
        "name" => "Edge Cases",
        "empty" => "",
        "zero" => "0"
      )
    )

  )
);

$result = \fpondepeyre\XmlToArray\XmlToArray::convert($xmlstr);

if ($result == $expected) {
	prettyPrint('Result', 'SUCCESS :-)');
} else {
	prettyPrint('Result', 'FAILURE :-(');
	prettyPrint('Input', $xmlstr);
    prettyPrint('Expected', $expected);
    prettyPrint('Output', $result);
	prettyPrint('Result', 'FAILURE :-(');
}
