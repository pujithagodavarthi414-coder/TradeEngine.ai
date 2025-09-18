CREATE PROCEDURE [dbo].[Marker55]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

UPDATE HtmlTemplates SET
HtmlTemplate = '
<!DOCTYPE html   PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <!--[if !mso]><!-->     
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <!--<![endif]-->     
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title></title>
      <style type="text/css">         * {             -webkit-font-smoothing: antialiased;         }                  body {             Margin: 0;             padding: 0;             min-width: 100%;             font-family: Arial, sans-serif;             -webkit-font-smoothing: antialiased;             mso-line-height-rule: exactly;         }                  table {             border-spacing: 0;             color: #333333;             font-family: Arial, sans-serif;         }                  img {             border: 0;         }                  .wrapper {             width: 100%;             table-layout: fixed;             -webkit-text-size-adjust: 100%;             -ms-text-size-adjust: 100%;         }                  .webkit {             max-width: 600px;         }                  .outer {             Margin: 0 auto;             width: 100%;             max-width: 600px;         }                  .full-width-image img {             width: 100%;             max-width: 600px;             height: auto;         }                  .inner {             padding: 10px;         }                  p {             Margin: 0;             padding-bottom: 10px;         }                  .h1 {             font-size: 21px;             font-weight: bold;             Margin-top: 15px;             Margin-bottom: 5px;             font-family: Arial, sans-serif;             -webkit-font-smoothing: antialiased;         }                  .h2 {             font-size: 18px;             font-weight: bold;             Margin-top: 10px;             Margin-bottom: 5px;             font-family: Arial, sans-serif;             -webkit-font-smoothing: antialiased;         }                  .one-column .contents {             text-align: left;             font-family: Arial, sans-serif;             -webkit-font-smoothing: antialiased;         }                  .one-column p {             font-size: 14px;             Margin-bottom: 10px;             font-family: Arial, sans-serif;             -webkit-font-smoothing: antialiased;         }                  .two-column {             text-align: center;             font-size: 0;         }                  .two-column .column {             width: 100%;             max-width: 300px;             display: inline-block;             vertical-align: top;         }                  .contents {             width: 100%;         }                  .two-column .contents {             font-size: 14px;             text-align: left;         }                  .two-column img {             width: 100%;             max-width: 280px;             height: auto;         }                  .two-column .text {             padding-top: 10px;         }                  .three-column {             text-align: center;             font-size: 0;             padding-top: 10px;             padding-bottom: 10px;         }                  .three-column .column {             width: 100%;             max-width: 200px;             display: inline-block;             vertical-align: top;         }                  .three-column .contents {             font-size: 14px;             text-align: center;         }                  .three-column img {             width: 100%;             max-width: 180px;             height: auto;         }                  .three-column .text {             padding-top: 10px;         }                  .img-align-vertical img {             display: inline-block;             vertical-align: middle;         }                  .download-button {             background-color: #009999;             border: none;             color: white;             padding: 15px 32px;             text-align: center;             text-decoration: none;             display: inline-block;             font-size: 16px;             margin: 4px 2px;             cursor: pointer;         }                  @@media only screen and (max-device-width: 480px) {             table[class=hide], img[class=hide], td[class=hide] {                 display: none !important;             }             .contents1 {                 width: 100%;             }             .contents1 {                 width: 100%;             }         }     </style>
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
                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">                                                                                                                 <a href="#" target="_blank">                                                                                                                     <img src="" alt="" width="60" height="60" style="border-width:0; max-width:60px;height:auto; display:block" align="left" />                                                                                                                 </a>                                                                                                             </td>
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
                                       <p style="color:#000000; font-size:14px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                     <br />The following asset(s) ##assets## with codes ##assetNumbers## has been assigned to you.</p>
                                       <div style="width: 100%;text-align: center;">                                                     <button class="download-button" target="_blank" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;            background-color: #009999;border: none;color: white;padding: 15px 32px;text-align: center;text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px;cursor: pointer; ">                                                         <a style="text-decoration:none;text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff" " href="##siteAddress##">Click here to take action</a>                        </button>                            </div>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                        <br/>                                                            Best Regards, <br/>                                              BTrak Team                                   </p>
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
'
WHERE TemplateName = 'AssetNotificationTemplate' 

END
GO