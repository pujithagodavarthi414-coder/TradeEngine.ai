CREATE PROCEDURE [dbo].[Marker3]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
   MERGE INTO [dbo].[HtmlTemplates] AS Target 
        USING ( VALUES 
                 (NEWID(),'ResetPasswordTemplate',
        '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
            <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
                    <tr>
                        <td width="100%">
                            <div class="webkit" style="max-width:600px;Margin:0 auto;">
                                <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                                    <tr>
                                        <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <center>
                                                                            <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                                <tr>
                                                                                                    <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                        <div class="column" style="width:100%;max-width:80px;display:inline-block;vertical-align:top;">
                                                                                                            <table class="contents" style="border-spacing:0; width:100%">
                                                                                                                <tr>
                                                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left"><a href="#" target="_blank"><img src="" alt="" width="60" height="60" style="border-width:0; max-width:60px;height:auto; display:block" align="left" /></a></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                        <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                            <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                        <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr></tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </center>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                                <tr>
                                                    <td align="left" style="padding:50px 50px 50px 50px">
                                                        <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"><h2>Dear ##userName##,</h2></p>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            Please reset your password by clicking on the below button.<br />
                                                            <br />
                                                            <br />
                                                        </p>
                                                        <table border="0" align="left" cellpadding="0" cellspacing="0" style="Margin:0 auto;">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <table border="0" cellpadding="0" cellspacing="0" style="Margin:0 auto;">
                                                                            <tr>
                                                                                <td width="250" height="60" align="center" bgcolor="#009999" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;"><a href= "##resetPasswordLink##" style="width:250px; display:block; text-decoration:none; border:0; text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff">Reset Password</a></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            <br />
                                                            <br />
                                                            <br />
                                                            <br />
                                                            <br />
                                                            Best Regards, <br />
                                                            ##footerName##
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </center>
        </body>
        </html>'
        ,'2019-10-18',@UserId,@CompanyId)
        ,(NEWID(),'CompanyRegistrationTemplate'
        ,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
            <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
                    <tr>
                        <td width="100%">
                            <div class="webkit" style="max-width:600px;Margin:0 auto;">
                                <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                                    <tr>
                                        <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <center>
                                                                            <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                                <tr>
                                                                                                    <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                        <div class="column" style="width:100%;max-width:80px;display:inline-block;vertical-align:top;">
                                                                                                            <table class="contents" style="border-spacing:0; width:100%">
                                                                                                                <tr>
                                                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                                                        @*<a href="#" target="_blank"><img src="" alt="" width="60" height="60" style="border-width:0; max-width:60px;height:auto; display:block" align="left" /></a>*@
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                        <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                            <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                        <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr></tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </center>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                                <tr>
                                                    <td align="left" style="padding:50px 50px 50px 50px">
                                                        <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"><h2>Dear ##ToName##,</h2></p>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            Thank you for choosing Snovasys Business Suite to grow your business.Hope you have a great success in the coming future.<a target="_blank" href="##siteAddress##" style="color: #099">Click here</a> to go to your site.<br />
                                                            <br />
                                                        </p>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            Best Regards, <br />
                                                            ##footerName##
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </center>
        </body>
        </html>
        ',
        '2019-10-18',@UserId,@CompanyId)
        ,(NEWID(),'CompanyRegistrationDemoDataTemplate'
        ,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
            <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
                    <tr>
                        <td width="100%">
                            <div class="webkit" style="max-width:600px;Margin:0 auto;">
                                <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                                    <tr>
                                        <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <center>
                                                                            <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                                <tr>
                                                                                                    <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                        <div class="column" style="width:100%;max-width:80px;display:inline-block;vertical-align:top;">
                                                                                                            <table class="contents" style="border-spacing:0; width:100%">
                                                                                                                <tr>
                                                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                                                    @*<a href="#" target="_blank"><img src="" alt="" width="60" height="60" style="border-width:0; max-width:60px;height:auto; display:block" align="left" /></a>*@
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                        <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                            <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                        <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr></tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </center>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                                <tr>
                                                    <td align="left" style="padding:50px 50px 50px 50px">
                                                        <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"><h2>Dear ##ToName##,</h2></p>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            Thank you for choosing Snovasys Business Suite to grow your business.Hope you have a great success in the coming future.We are creating your site, once it is finished, we will let you know.Please go through the below link and find the terms and conditions of Snovasys Business Suite<br />
                                                            <br />
                                                            <br />
                                                        </p>
                                                        <table border="0" align="left" cellpadding="0" cellspacing="0" style="Margin:0 auto;">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <table border="0" cellpadding="0" cellspacing="0" style="Margin:0 auto;">
                                                                            <tr>
                                                                                <td width="250" height="60" align="center" bgcolor="#009999" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;"><a href="https://snovasys.com/Documents/SnovasysTerms.pdf" style="width:250px; display:block; text-decoration:none; border:0; text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff">Terms and Conditions</a></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            <br />
                                                            <br />
                                                            <br />
                                                            <br />
                                                            <br />
                                                            Best Regards, <br />
                                                            ##footerName##
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </center>
        </body>
        </html>
        ',
        '2019-10-18',@UserId,@CompanyId)
        ,(NEWID(),'TestRailReportTemplate'
        ,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                .download-button {
                    background-color: #4CAF50;
                    border: none;
                    color: white;
                    padding: 15px 32px;
                    text-align: center;
                    text-decoration: none;
                    display: inline-block;
                    font-size: 16px;
                    margin: 4px 2px;
                    cursor: pointer;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
            <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
                    <tr>
                        <td width="100%">
                            <div class="webkit" style="max-width:600px;Margin:0 auto;">
                                <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                                    <tr>
                                        <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <center>
                                                                            <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                                <tr>
                                                                                                    <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                        <div class="column" style="width:100%;max-width:80px;display:inline-block;vertical-align:top;">
                                                                                                            <table class="contents" style="border-spacing:0; width:100%">
                                                                                                                <tr>
                                                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left"><a href="#" target="_blank"><img src="" alt="" width="60" height="60" style="border-width:0; max-width:60px;height:auto; display:block" align="left" /></a></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                        <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                            <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                        <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr></tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </center>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                                <tr>
                                                    <td align="left" style="padding:50px 50px 50px 50px">
                                                        <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"><h2>Dear User ,</h2></p>
                                                        <p style="color:#000000; font-size:14px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            The following Testrepo report was sent to you:<br /><br />
                                                            <b>##ReportName##</b><br /><br />
                                                            If the email contains a PDF, after downloading it you can open it in your preferred PDF viewer.<br />
                                                        </p>
                                                        <a class="download-button" href="##PdfUrl##" target="_blank">Click here to download report</a>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            <br />
                                                            Best Regards, <br />
                                                            ##footerName##
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </center>
        </body>
        </html>',
        '2019-10-18',@UserId,@CompanyId)
        ,(NEWID(),'LeaveApplicationTemplate'
        ,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                .download-button {
                    background-color: #009999;
                    border: none;
                    color: white;
                    padding: 15px 32px;
                    text-align: center;
                    text-decoration: none;
                    display: inline-block;
                    font-size: 16px;
                    margin: 4px 2px;
                    cursor: pointer;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
            <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
                    <tr>
                        <td width="100%">
                            <div class="webkit" style="max-width:600px;Margin:0 auto;">
                                <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                                    <tr>
                                        <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <center>
                                                                            <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                                <tr>
                                                                                                    <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                        <div class="column" style="width:100%;max-width:80px;display:inline-block;vertical-align:top;">
                                                                                                            <table class="contents" style="border-spacing:0; width:100%">
                                                                                                                <tr>
                                                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left"><a href="#" target="_blank"><img src="" alt="" width="60" height="60" style="border-width:0; max-width:60px;height:auto; display:block" align="left" /></a></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                        <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                            <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                        <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr></tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </center>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                                <tr>
                                                    <td align="left" style="padding:50px 50px 50px 50px">
                                                        <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"><h2>Dear sir/madam ,</h2></p>
                                                        <p style="color:#000000; font-size:14px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            <br />##ToName## has applied leave from ##leaveFromDate## to ##leaveDateTo## for ##NoofDays## day(s)
                                                        </p>
                                                       <div style="width: 100%;text-align: center;">
        													<button class="download-button" target="_blank" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;            background-color: #009999;border: none;color: white;padding: 15px 32px;text-align: center;text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px;cursor: pointer; ">
        														<a style="text-decoration:none;text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff"" href="##siteAddress##">Click here to Accept/Decline</a> 
        													</button>      
        												</div>   
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            <br />
                                                            Best Regards, <br />
                                                            BTrak Team
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </center>
			</body>
        </html>',
        '2019-10-18',@UserId,@CompanyId)
        ,(NEWID(),'AssetNotificationTemplate'
        ,'<!DOCTYPE html
  PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <!--[if !mso]><!-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!--<![endif]-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title></title>
    <style type="text/css">
        * {
            -webkit-font-smoothing: antialiased;
        }
        
        body {
            Margin: 0;
            padding: 0;
            min-width: 100%;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
            mso-line-height-rule: exactly;
        }
        
        table {
            border-spacing: 0;
            color: #333333;
            font-family: Arial, sans-serif;
        }
        
        img {
            border: 0;
        }
        
        .wrapper {
            width: 100%;
            table-layout: fixed;
            -webkit-text-size-adjust: 100%;
            -ms-text-size-adjust: 100%;
        }
        
        .webkit {
            max-width: 600px;
        }
        
        .outer {
            Margin: 0 auto;
            width: 100%;
            max-width: 600px;
        }
        
        .full-width-image img {
            width: 100%;
            max-width: 600px;
            height: auto;
        }
        
        .inner {
            padding: 10px;
        }
        
        p {
            Margin: 0;
            padding-bottom: 10px;
        }
        
        .h1 {
            font-size: 21px;
            font-weight: bold;
            Margin-top: 15px;
            Margin-bottom: 5px;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }
        
        .h2 {
            font-size: 18px;
            font-weight: bold;
            Margin-top: 10px;
            Margin-bottom: 5px;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }
        
        .one-column .contents {
            text-align: left;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }
        
        .one-column p {
            font-size: 14px;
            Margin-bottom: 10px;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }
        
        .two-column {
            text-align: center;
            font-size: 0;
        }
        
        .two-column .column {
            width: 100%;
            max-width: 300px;
            display: inline-block;
            vertical-align: top;
        }
        
        .contents {
            width: 100%;
        }
        
        .two-column .contents {
            font-size: 14px;
            text-align: left;
        }
        
        .two-column img {
            width: 100%;
            max-width: 280px;
            height: auto;
        }
        
        .two-column .text {
            padding-top: 10px;
        }
        
        .three-column {
            text-align: center;
            font-size: 0;
            padding-top: 10px;
            padding-bottom: 10px;
        }
        
        .three-column .column {
            width: 100%;
            max-width: 200px;
            display: inline-block;
            vertical-align: top;
        }
        
        .three-column .contents {
            font-size: 14px;
            text-align: center;
        }
        
        .three-column img {
            width: 100%;
            max-width: 180px;
            height: auto;
        }
        
        .three-column .text {
            padding-top: 10px;
        }
        
        .img-align-vertical img {
            display: inline-block;
            vertical-align: middle;
        }
        
        .download-button {
            background-color: #009999;
            border: none;
            color: white;
            padding: 15px 32px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
        }
        
        @@media only screen and (max-device-width: 480px) {
            table[class=hide], img[class=hide], td[class=hide] {
                display: none !important;
            }
            .contents1 {
                width: 100%;
            }
            .contents1 {
                width: 100%;
            }
        }
    </style>
</head>

<body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
    <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
        <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
                <td width="100%">
                    <div class="webkit" style="max-width:600px;Margin:0 auto;">
                        <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                            <tr>
                                <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                    <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td>
                                                <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                    <tbody>
                                                        <tr>
                                                            <td align="center">
                                                                <center>
                                                                    <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                        <tr>
                                                                                            <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                <div class="column" style="width:100%;max-width:80px;display:inline-block;vertical-align:top;">
                                                                                                    <table class="contents" style="border-spacing:0; width:100%">
                                                                                                        <tr>
                                                                                                            <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                                                <a href="#" target="_blank">
                                                                                                                    <img src="" alt="" width="60" height="60" style="border-width:0; max-width:60px;height:auto; display:block" align="left" />
                                                                                                                </a>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </div>
                                                                                                <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                    <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                        <tr>
                                                                                                            <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                    <tr>
                                                                                                                        <td align="left" valign="top">&nbsp;</td>
                                                                                                                    </tr>
                                                                                                                    <tr></tr>
                                                                                                                </table>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </center>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                        <tr>
                                            <td align="left" style="padding:50px 50px 50px 50px">
                                                <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                                    <h2>Dear ##userName## ,</h2>
                                                </p>
                                                <p style="color:#000000; font-size:14px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    <br />The following asset(s) ##assets## with codes ##assetNumbers## has been assigned to you.</p>
                                                <div style="width: 100%;text-align: center;">
                                                    <button class="download-button" target="_blank" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;            background-color: #009999;border: none;color: white;padding: 15px 32px;text-align: center;text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px;cursor: pointer; ">
                                                        <a style="text-decoration:none;text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff" " href="##siteAddress## ">Click here to take action</a>                        </button>                            </div>                                                             <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                       
<br/>                                                           
Best Regards, <br/>                                             
BTrak Team                                  
</p>                                
</td>                               
</tr>                          
</table>                        
</td>                     
</tr>                    
</table>                
</div>             
</td>             
</tr>              
</table>          
</center>  
</body>
</html>','2019-10-18',@UserId,@CompanyId)
--        ,(NEWID(), 'EmployeeRosterTemplate'
--,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head> <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> <meta http-equiv="X-UA-Compatible" content="IE=edge"/> <meta name="viewport" content="width=device-width, initial-scale=1.0"/> <title></title> <style type="text/css"> *{-webkit-font-smoothing: antialiased;}body{Margin: 0; padding: 0; min-width: 100%; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased; mso-line-height-rule: exactly;}table{border-spacing: 0; color: #333333; font-family: Arial, sans-serif;}img{border: 0;}.wrapper{width: 100%; table-layout: fixed; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%;}.webkit{max-width: 600px;}.outer{Margin: 0 auto; width: 100%; max-width: 600px;}.full-width-image img{width: 100%; max-width: 600px; height: auto;}.inner{padding: 10px;}p{Margin: 0; padding-bottom: 10px;}.h1{font-size: 21px; font-weight: bold; Margin-top: 15px; Margin-bottom: 5px; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased;}.h2{font-size: 18px; font-weight: bold; Margin-top: 10px; Margin-bottom: 5px; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased;}.one-column .contents{text-align: left; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased;}.one-column p{font-size: 14px; Margin-bottom: 10px; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased;}.two-column{text-align: center; font-size: 0;}.two-column .column{width: 100%; max-width: 300px; display: inline-block; vertical-align: top;}.contents{width: 100%;}.two-column .contents{font-size: 14px; text-align: left;}.two-column img{width: 100%; max-width: 280px; height: auto;}.two-column .text{padding-top: 10px;}.three-column{text-align: center; font-size: 0; padding-top: 10px; padding-bottom: 10px;}.three-column .column{width: 100%; max-width: 200px; display: inline-block; vertical-align: top;}.three-column .contents{font-size: 14px; text-align: center;}.three-column img{width: 100%; max-width: 180px; height: auto;}.three-column .text{padding-top: 10px;}.img-align-vertical img{display: inline-block; vertical-align: middle;}.download-button{background-color: #4CAF50; border: none; color: white; padding: 15px 32px; text-align: center; text-decoration: none; display: inline-block; font-size: 16px; margin: 4px 2px; cursor: pointer;}@@media only screen and (max-device-width: 480px){table[class=hide], img[class=hide], td[class=hide]{display: none !important;}.contents1{width: 100%;}.contents1{width: 100%;}}.tabletd{width: 25%; vertical-align: top; padding:2px 5px 2px 5px;}.tabletd p{margin:5px 0}</style></head><body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;"> <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;"> <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;"> <tr> <td width="100%"> <div class="webkit" style="max-width:600px;Margin:0 auto;"> <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;"> <tr> <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;"> <table border="0" width="100%" cellpadding="0" cellspacing="0"> <tr> <td> <table style="width:100%;" cellpadding="0" cellspacing="0" border="0"> <tbody> <tr> <td align="center"> <center> <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;"> <tbody> <tr> <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF"> <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0"> <tr> <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;"> <div class="column" style="width:100%;max-width:80px;display:inline-block;vertical-align:top;"> <table class="contents" style="border-spacing:0; width:100%"> <tr> <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left"> <a href="#" target="_blank"><img src="" alt="" width="60" height="60" style="border-width:0; max-width:60px;height:auto; display:block" align="left"/></a> </td></tr></table> </div><div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;"> <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0"> <tr> <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;"> <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0"> <tr> <td align="left" valign="top"> &nbsp; </td></tr><tr> </tr></table> </td></tr></table> </div></td></tr><tr> <td>&nbsp;</td></tr></table> </td></tr></tbody> </table> </center> </td></tr></tbody> </table> </td></tr></table> <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF"> <tr> <td align="left" style="padding:50px 50px 50px 50px"> <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"> <h2>Dear User ,</h2> </p><p style="color:#000000; font-size:14px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px "> Please check the below roster created by <b>Mr. Praveen</b> and have to follow the same please let us know in person, if you have any changes or queries<br/><br/> <table border="1" cellspacing="0" cellpadding="0" style="border-collapse:separate"> <tr> <th>Employee Name</th> <th>Scheduled Day</th> <th>Scheduled Time</th> <th>Department</th> </tr>##EmployeeRoster## </table> <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px "> <br/> Best Regards, <br/> ##footerName## </p></td></tr></table> </td></tr></table> </div></td></tr></table> </center></body></html>'
--,'2019-10-18',@UserId,@CompanyId)
        ,(NEWID(), N'InvoicePDFTemplate',
		'<!DOCTYPE html>
<html>

<style>
    .div {
        box-sizing: border-box;
    }

    .p-1 {
        padding: 1rem !important;
    }

    h6 {
        font-size: 1rem;
        margin-bottom: .5rem;
        font-weight: 400;
        line-height: 1.1;
        color: inherit;
        margin-top: 0;
    }

    .fxLayout-row {
        flex-flow: row wrap;
        box-sizing: border-box;
        display: flex;
    }

    .fxFlex48 {
        flex: 1 1 100%;
        box-sizing: border-box;
        max-width: 48%;
    }

    .fxFlex {
        flex: 1 1 0%;
        box-sizing: border-box;
    }

    .fxFlex49-column {
        flex: 1 1 100%;
        box-sizing: border-box;
        flex-direction: column;
        display: flex;
        max-width: 49%;
    }

    .fxFlex50-row-start {
        flex: 1 1 50%;
        box-sizing: border-box;
        place-content: center flex-start;
        align-items: center;
        flex-direction: row;
        display: flex;
        max-width: 50%;
    }

    .fxFlex50-column-start {
        flex: 1 1 50%;
        box-sizing: border-box;
        place-content: center flex-start;
        align-items: center;
        flex-direction: column;
        display: block;
        max-width: 50%;
    }

    .fxFlex50-column-end {
        flex: 1 1 50%;
        box-sizing: border-box;
        place-content: flex-start flex-end;
        align-items: center;
        flex-direction: column;
        display: block;
        max-width: 50%;
    }

    .fxFlex100 {
        flex: 1 1 100%;
        box-sizing: border-box;
        max-width: 100%;
    }

    .fxFlex100-end {
        flex: 1 1 100%;
        box-sizing: border-box;
        place-content: flex-start flex-end;
        align-items: flex-start;
        flex-direction: row;
        display: flex;
        max-width: 100%;
    }

    .fxLayout-end {
        place-content: center flex-end;
        align-items: center;
        flex-direction: row;
        box-sizing: border-box;
        display: flex;
    }

    .word-break {
        word-break: break-word !important;
    }

    .d-block {
        display: bloack !important;
    }

    .mb-1 {
        margin-bottom: 1rem !important;
    }

    .mt-02 {
        margin-top: .3rem !important;
    }

    .mt-1 {
        margin-top: 1rem !important;
    }

    .mt-1-05 {
        margin-top: 1.5rem;
    }

    .ml-1 {
        margin-left: 1rem !important;
    }

    .mt-05 {
        margin-top: .5rem !important;
    }
    
    .mr-05 {
        margin-right: .5rem !important;
    }

    .invoice-amount-price {
        font-size: 23px;
        font-weight: 700;
        position: relative;
        top: 1px;
    }

    .overflow-visible {
        overflow: visible;
    }

    .table-responsive {
        display: block;
        width: 100%;
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
    }

    .mb-0 {
        margin-bottom: 0 !important;
    }

    .table {
        width: 100%;
        margin-bottom: 1rem;
        color: #212529;
    }

    table {
        border-collapse: collapse;
    }

    .invoice-container td:first-child,
    .invoice-container th:first-child {
        text-align: inherit;
        padding-left: 0;
        width: 40%;
    }

    .table thead th {
        vertical-align: bottom;
        border-bottom: 2px solid #dee2e6;
    }

    .invoice-container td,
    .invoice-container th {
        padding-right: 0;
        text-align: right;
        width: 13%;
    }

    .table td,
    .table th {
        padding: .75rem;
        vertical-align: top;
        border-top: 1px solid #dee2e6;
    }

	td    { page-break-before: always; }
	th    { page-break-before: always; }

	@page {
		margin-top: 10px;
		margin-bottom: 10px
	}
</style>

<body>
    <div class="p-1 invoice-preview-height">
		##invoicePDFJson##
	</div>
</body>

</html>
		',
		'2020-03-09', @UserId,@CompanyId)
        ,(NEWID(), N'InvoiceMailTemplate',
		'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body
    style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
    <center class="wrapper"
        style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
        <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;"
            bgcolor="#f3f2f0;">
            <tr>
                <td width="100%">
                    <div class="webkit" style="max-width:600px;Margin:0 auto;">
                        <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0"
                            style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                            <tr>
                                <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                    <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%"
                                        style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5"
                                        bgcolor="#FFFFFF">
                                        <tr>
                                            <td align="left" style="padding:50px 50px 50px 50px">
                                                <p
                                                    style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                                    <h2>Dear ##ToName##,</h2>
                                                </p>
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Thank you for choosing Snovasys Business Suite to grow your
                                                    business.Hope you have a great success in the coming future.<a
                                                        target="_blank" href="##PdfUrl##" style="color: #099">Click
                                                        here</a> to download the invoice.<br />
                                                    <br />
                                                </p>
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Best Regards, <br />
                                                    ##footerName##
                                                </p>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </center>
</body>
</html>','2020-03-10', @UserId,@CompanyId)
        ,(NEWID(), N'ScenarioExportMailTemplate',
        '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body
    style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
    <center class="wrapper"
        style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
        <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;"
            bgcolor="#f3f2f0;">
            <tr>
                <td width="100%">
                    <div class="webkit" style="max-width:600px;Margin:0 auto;">
                        <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0"
                            style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                            <tr>
                                <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                    <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%"
                                        style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5"
                                        bgcolor="#FFFFFF">
                                        <tr>
                                            <td align="left" style="padding:50px 50px 50px 50px">
                                                <p
                                                    style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                                    <h2>Dear ##ToName##,</h2>
                                                </p>
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Thank you for choosing Snovasys Business Suite to grow your
                                                    business.Hope you have a great success in the coming future. <a
                                                        target="_blank" href="##PdfUrl##" style="color: #099">Click
                                                        here</a> to download the exported file.<br />
                                                    <br />
                                                </p>
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Best Regards, <br />
                                                    ##footerName##
                                                </p>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </center>
</body>
</html>','2020-03-26', @UserId,@CompanyId)
        )
        AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        ON Target.Id = Source.Id  
        WHEN MATCHED THEN 
        UPDATE SET [TemplateName] = Source.[TemplateName],
                   [HtmlTemplate] = Source.[HtmlTemplate],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId],
                   [CompanyId] = Source.[CompanyId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]);
END
GO