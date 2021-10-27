<?php
$url = ((isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == "on") ? "https" : "http");
$url .= "://".$_SERVER['HTTP_HOST'];
$url .= "/redcap/api/";
$token = getenv('VersionApiToken');
$options = array(
  'http' => array(
    'header'  => "Content-type: application/x-www-form-urlencoded\r\nAccept: application/json\r\n",
    'method'  => 'POST',
    'content' => "content=version&token=$token"
  )
);
$api_response = file_get_contents($url, false, stream_context_create($options));
if (preg_match("/[0-9]{1,4}\.[0-9]{1,4}\.[0-9]{1,4}/", $api_response)) {
  $version = explode(".", $api_response);
  $rc_version = "Version $version[0]";
  $button_text = "REDCap $rc_version Production Server";
} else {
  $rc_version = "";
  $button_text = "This REDCap server is currently offline";
}
?>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>REDCap </title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="shortcut icon" href="landing_page_files/favicon.ico">
  <link rel="apple-touch-icon" href="landing_page_files/apple-touch-icon.png">
  <link rel="stylesheet" id="wusm-css" href="landing_page_files/style.css" type="text/css" media="all">
  <link rel="stylesheet" id="dashicons-css" href="landing_page_files/dashicons.css" type="text/css" media="all">
  <style>
    .rc-logo {
      margin-top: 1.25em;
    }

    h1 {
      font-size: 120%;
      margin: 1em 0em 1em 0em;
    }

    fieldset {
      width: 400px;
      border-radius: 5px;
      border-width: 2px;
      border-style: groove;
      border-color: #990000;
      border-image: initial;
      border: 2;
      padding: 0.5em;
      margin-bottom: 2em;
    }

    legend {
      float: left;
      margin-bottom: 1em;
    }

    fieldset a {
      font-family: 'Open Sans', sans-serif;
      font-size: 14px;
      color: #333;
      display: block;
      text-align: center;
      align-items: flex-start;
      cursor: pointer;
      background-color: rgb(239, 239, 239);
      box-sizing: border-box;
      margin: 0em;
      padding: 2px 6px;
      border-width: 1px;
      border-style: outset;
      border-color: #333;
      border-image: initial;
      border-radius: 3px;
      margin-bottom: 0.5em;
    }

    fieldset a:hover {
      color: #333;
      background-color: rgb(225, 225, 225);
    }

    footer {
      padding-top: 5em;
    }

    .contact-us-text {
      font-size: 85%;
    }
  </style>
  <script>
    //refactored to keep image fallback, but not sure it's needed
    function imageFallback(e, filename) {
      if (filename == null) {
        filename = segments[segments.length - 1].replace('.svg', '.png');
        let segments = e.src.split('/');
      }
      e.src = 'https://webtheme.med.wustl.edu/wp-content/themes/wusm/_/img/' + filename;
      e.onerror = null;
    }
  </script>
</head>

<body>
  <header>
    <div id="header-logo-row" class="clearfix">
      <div class="wrapper clearfix">
        <div id="header-logo">
          <a href="http://informatics.wustl.edu/"><img src="landing_page_files/wusm-i2-1line.png" onerror="imageFallback(this, 'wusm-logo.png')" alt="Washington University Institute for Informatics" width="300" height="18"></a>
        </div>
        <nav id="utility-bar">
          <ul id="utility-nav">
            <li>
              <a href="http://wustl.edu/">WUSTL</a>
            </li>
            <li>
              <a href="http://medicine.wustl.edu/">WUSM</a>
            </li>
            <li>
              <a href="http://informatics.wustl.edu/">I<sup>2</sup>
              </a>
            </li>
          </ul>
        </nav>
      </div>
    </div>
  </header>
  <div id="main" class="clearfix">
    <div align="center">
      <img class="rc-logo" src='landing_page_files/redcap logo.png' title="RedCap" alt="" width="600">
      <p>
        <small>REDCap is a secure, web-based application for building and managing online databases.</small>
      </p>
      <h1>Welcome to REDCap. Please choose from the options below:</h1>
      <fieldset>
        <legend>
          <small>
            <b><?= $rc_version ?></b>
          </small>
        </legend>
        <div class="clearfix"></div>
        <div>
          <a href="/login.php"><?= $button_text ?></a>
          <small>WUSTL key is required for this REDCap server.</small>
        </div>
      </fieldset>
      <fieldset>
        <legend>
          <small>
            <b>Version 7</b>
          </small>
        </legend>
        <div class="clearfix"></div>
        <div>
          <a href="/redcap/srvrs/prod_v3_1_0_001/redcap/">REDCap Version 7 Production Server</a>
          <a href="/redcap/srvrs/dev_v3_1_0_001/redcap/">REDCap Version 7 Demo Server</a>
        </div>
      </fieldset>
    </div>
  </div>
  <footer>
    <div id="site-footer">
      <div class="wrapper">
        <div id="site-footer-bottom" class="clearfix">
          <p class="contact-us-text">
            If you require assistance or have any questions about REDCap, please contact the
            WUSTL REDCap Administrators at the <a href="mailto:redcap_helpdesk@wustl.edu?subject=REDCap Inquiry">REDCap Help Desk
              [redcap_helpdesk@wustl.edu]</a>
          </p>
        </div>
      </div>
    </div>
    <div id="wusm-footer">
      <div class="wrapper clearfix">
        <div id="wusm-footer-left">
          <a href="http://medicine.wustl.edu/"><img src="landing_page_files/wusm-logo-footer.svg" onerror="imageFallback(this, 'wusm-logo-footer.png')" alt="Washington University School of Medicine in St. Louis" width="147" height="31"></a>
          <div id="copyright">
            <a href="http://www.wustl.edu/policies/copyright.html">&copy; 2018-<?=date("Y")?>
              Washington University in St. Louis</a>
          </div>
        </div>
        <div id="wusm-footer-right">
          <div id="wusm-social">
            <a id="wusm-facebook" title="Facebook" href="https://www.facebook.com/WUSTLmedicine.health">
              <img src="landing_page_files/facebook.svg" onerror="imageFallback(this, 'facebook.png')"></a>
            <a id="wusm-twitter" title="Twitter" href="http://twitter.com/WUSTLmed">
              <img src="landing_page_files/twitter.svg" onerror="imageFallback(this, 'twitter.png')"></a>
            <a id="wusm-flickr" title="Flickr" href="https://www.flickr.com/photos/wustlmedicine/">
              <img src="landing_page_files/flickr.svg" onerror="imageFallback(this, 'flickr.png')"></a>
          </div>
          <nav>
            <a class="first-child" href="http://emergency.wustl.edu/">Emergency</a>
            <a href="http://medicine.wustl.edu/policies">Policies</a>
            <a class="last-child" href="http://medicine.wustl.edu/news/">News</a>
          </nav>
        </div>
      </div>
    </div>
  </footer>
</body>

</html>