CREATE PROCEDURE [dbo].[Marker370]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @Template TABLE
	(
		EmailTemplateName NVARCHAR(250)
		,[EmailTemplate] NVARCHAR(MAX)
		,[EmailSubject] NVARCHAR(2000)
        ,[EmailTemplateReferenceId] UNIQUEIDENTIFIER
	)

	INSERT INTO @Template(EmailTemplateName,EmailTemplate,EmailSubject,EmailTemplateReferenceId)
	VALUES('ClientRegistrationMail','<!doctype html>   
    <html lang="en">
       <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
          <meta name="x-apple-disable-message-reformatting">
          <meta http-equiv="X-UA-Compatible" content="IE=edge">
          <title>Account New Sign-in</title>
          <style type="text/css">      a { text-decoration: none; outline: none; }      @media (max-width: 649px) {     .o_col-full { max-width: 100% !important; }     .o_col-half { max-width: 50% !important; }     .o_hide-lg { display: inline-block !important; font-size: inherit !important; max-height: none !important; line-height: inherit !important; overflow: visible !important; width: auto !important; visibility: visible !important; }     .o_hide-xs, .o_hide-xs.o_col_i { display: none !important; font-size: 0 !important; max-height: 0 !important; width: 0 !important; line-height: 0 !important; overflow: hidden !important; visibility: hidden !important; height: 0 !important; }     .o_xs-center { text-align: center !important; }     .o_xs-left { text-align: left !important; }     .o_xs-right { text-align: left !important; }     table.o_xs-left { margin-left: 0 !important; margin-right: auto !important; float: none !important; }     table.o_xs-right { margin-left: auto !important; margin-right: 0 !important; float: none !important; }     table.o_xs-center { margin-left: auto !important; margin-right: auto !important; float: none !important; }     h1.o_heading { font-size: 32px !important; line-height: 41px !important; }     h2.o_heading { font-size: 26px !important; line-height: 37px !important; }     h3.o_heading { font-size: 20px !important; line-height: 30px !important; }     .o_xs-py-md { padding-top: 24px !important; padding-bottom: 24px !important; }     .o_xs-pt-xs { padding-top: 8px !important; }     .o_xs-pb-xs { padding-bottom: 8px !important; }      }      @media screen {     @font-face {       font-family: Roboto;       font-style: normal;       font-weight: 400;       src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");       unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }     @font-face {       font-family: Roboto;       font-style: normal;       font-weight: 400;       src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");       unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }     @font-face {       font-family: Roboto;       font-style: normal;       font-weight: 700;       src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");       unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }     @font-face {       font-family: Roboto;       font-style: normal;       font-weight: 700;       src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");       unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }     .o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }     .o_heading, strong, b { font-weight: 700 !important; }     a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }      }    </style>
          <!--[if mso]>    
          <style>      table { border-collapse: collapse; }      .o_col { float: left; }    </style>
          <xml>
             <o:OfficeDocumentSettings>
                <o:PixelsPerInch>96</o:PixelsPerInch>
             </o:OfficeDocumentSettings>
          </xml>
          <![endif]-->     
       </head>
       <body class="o_body o_bg-light" style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
          <!-- preview-text -->    
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_hide" align="center" style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">Email Summary (Hidden)</td>
                </tr>
             </tbody>
          </table>
          <!-- header-primary -->    
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                                              <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white" style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyRegistrationLogo##" width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a></p>
                                           </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <!-- hero-white-icon-outline -->    
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
                                              <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                                                 <tbody>
                                                    <tr>
                                                       <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">          <img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">           </td>
                                                    </tr>
                                                    <tr>
                                                       <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                                    </tr>
                                                 </tbody>
                                              </table>
                                              <h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">You''ve Been Invited</h2>
                                              <p style="margin-top: 0px;margin-bottom: 0px;">Welcome to ##CompanyName##!</p>
                                           </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <!-- device-row -->          
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                                              <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                                                 <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                                    <tbody>
                                                       <tr>
                                                          <td class="o_re o_bt-light" style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">&nbsp; </td>
                                                       </tr>
                                                    </tbody>
                                                 </table>
                                              </div>
                                              <p style="margin-top: 0px;margin-bottom: 0px;">We are pleased to have you joining our team. Are you ready to fall in love with your new job and meet your great new colleagues.</p>
                                              </p>         
                                           </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                                              <p style="margin-top: 0px;margin-bottom: 0px;">Please click the following link on your browser to join us.</p>
                                           </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                                              <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                                 <tbody>
                                                    <tr>
                                                       <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">          <a class="o_text-white" href="##siteUrl##" style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">Join Us</a>           </td>
                                                    </tr>
                                                 </tbody>
                                              </table>
                                           </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white o_px-md o_py o_sans o_text-xs o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                                              <p class="o_mb" style="margin-top: 0px;margin-bottom: 16px;"><strong>Username</strong></p>
                                              <table role="presentation" cellspacing="0" cellpadding="0" border="0">
                                                 <tbody>
                                                    <tr>
                                                       <td width="284" class="o_bg-ultra_light o_br o_text-xs o_sans o_px-xs o_py" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ebf5fa;border-radius: 4px;padding-left: 8px;padding-right: 8px;padding-top: 16px;padding-bottom: 16px;">
                                                          <p class="o_text-dark" style="color: #242b3d;margin-top: 0px;margin-bottom: 0px;"><strong>##UserName##</strong></p>
                                                       </td>
                                                    </tr>
                                                 </tbody>
                                              </table>
                                           </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <!-- label-xs -->    
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white o_px-md o_py o_sans o_text-xs o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                                              <p class="o_mb" style="margin-top: 0px;margin-bottom: 16px;"><strong>Password</strong></p>
                                              <table role="presentation" cellspacing="0" cellpadding="0" border="0">
                                                 <tbody>
                                                    <tr>
                                                       <td width="284" class="o_bg-ultra_light o_br o_text-xs o_sans o_px-xs o_py" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ebf5fa;border-radius: 4px;padding-left: 8px;padding-right: 8px;padding-top: 16px;padding-bottom: 16px;">
                                                          <p class="o_text-dark" style="color: #242b3d;margin-top: 0px;margin-bottom: 0px;"><strong>##Password##</strong></p>
                                                       </td>
                                                    </tr>
                                                 </tbody>
                                              </table>
                                           </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <!-- spacer -->    
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <!-- alert-primary -->         <!-- spacer -->    
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <!-- content -->    
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                                              <p style="margin-top: 0px;margin-bottom: 0px;">Thanks for choosing to be part of our company! We are all working towards a common goal and your contribution is integral. Congratulations and welcome aboard!</p>
                                           </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <!-- spacer-lg -->    
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white" style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp; </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <!-- footer-3cols -->    
          <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
             <tbody>
                <tr>
                   <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center" style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
                      <div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                         <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                         <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                            <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights reserved</p>
                            <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944    - info@snovasys.com</p>
                            <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road London - TW4 6JQ</p>
                            <p style="margin-top: 0px;margin-bottom: 0px;">           Learn more at <a class="o_text-dark_light o_underline" href=##Registersite## style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a>           </p>
                         </div>
                      </div>
                      <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->        
                      <div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                         <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                         <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                            <p style="margin-top:0;margin-bottom:0">        <a class="o_text-dark_light" href="https://www.facebook.com/snovasys" style="text-decoration:none;outline:0;color:#a0a3ab"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png" width="36" height="36" alt="fb" style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>                          <a class="o_text-dark_light" href="https://twitter.com/snovasys" style="text-decoration:none;outline:0;color:#a0a3ab"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png" width="36" height="36" alt="tw" style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>                          <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/" style="text-decoration:none;outline:0;color:#a0a3ab"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36" height="36" alt="ig" style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>                          </p>
                         </div>
                      </div>
                   </td>
                </tr>
             </tbody>
          </table>
       </body>
    </html>','User registration notification',N'D2675610-3BEA-428C-9515-D5726160BD6D')
    
	,('SendKYCRemindMail','<!doctype html>   
    <html lang="en">
       <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
          <meta name="x-apple-disable-message-reformatting">
          <meta http-equiv="X-UA-Compatible" content="IE=edge">
          <title>Account New Sign-in</title>
          <style type="text/css">      a { text-decoration: none; outline: none; }      @media (max-width: 649px) {     .o_col-full { max-width: 100% !important; }     .o_col-half { max-width: 50% !important; }     .o_hide-lg { display: inline-block !important; font-size: inherit !important; max-height: none !important; line-height: inherit !important; overflow: visible !important; width: auto !important; visibility: visible !important; }     .o_hide-xs, .o_hide-xs.o_col_i { display: none !important; font-size: 0 !important; max-height: 0 !important; width: 0 !important; line-height: 0 !important; overflow: hidden !important; visibility: hidden !important; height: 0 !important; }     .o_xs-center { text-align: center !important; }     .o_xs-left { text-align: left !important; }     .o_xs-right { text-align: left !important; }     table.o_xs-left { margin-left: 0 !important; margin-right: auto !important; float: none !important; }     table.o_xs-right { margin-left: auto !important; margin-right: 0 !important; float: none !important; }     table.o_xs-center { margin-left: auto !important; margin-right: auto !important; float: none !important; }     h1.o_heading { font-size: 32px !important; line-height: 41px !important; }     h2.o_heading { font-size: 26px !important; line-height: 37px !important; }     h3.o_heading { font-size: 20px !important; line-height: 30px !important; }     .o_xs-py-md { padding-top: 24px !important; padding-bottom: 24px !important; }     .o_xs-pt-xs { padding-top: 8px !important; }     .o_xs-pb-xs { padding-bottom: 8px !important; }      }      @media screen {     @font-face {       font-family: Roboto;       font-style: normal;       font-weight: 400;       src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");       unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }     @font-face {       font-family: Roboto;       font-style: normal;       font-weight: 400;       src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");       unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }     @font-face {       font-family: Roboto;       font-style: normal;       font-weight: 700;       src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");       unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }     @font-face {       font-family: Roboto;       font-style: normal;       font-weight: 700;       src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");       unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }     .o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }     .o_heading, strong, b { font-weight: 700 !important; }     a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }      }    </style>
          <!--[if mso]>    
          <style>      table { border-collapse: collapse; }      .o_col { float: left; }    </style>
          <xml>
             <o:OfficeDocumentSettings>
                <o:PixelsPerInch>96</o:PixelsPerInch>
             </o:OfficeDocumentSettings>
          </xml>
          <![endif]-->     
       </head>
       <body class="o_body o_bg-light" style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
          <!-- preview-text -->    
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_hide" align="center" style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">Email Summary (Hidden)</td>
                </tr>
    			
             </tbody>
    		 
          </table>
          <!-- header-primary -->    
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
    
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->				         
                   </td>
                </tr>
             </tbody>
          </table>
          <!-- hero-white-icon-outline -->    
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
    								   <tr>
                                                                                        <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">                                                                                        
    																					<a href="#" target="_blank"><img src= "##CompanyLogo##" alt="" width="160" height="160" style="border-width:0; height:auto; display:block" align="left" /></a>                                                                                      </td>
                                                                                     </tr>
                                        <tr>
                                           <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
                                              <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                                                 <tbody>
                                                    <tr>
                                                       <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">      
    												   <img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">           </td>
                                                    </tr>
                                                    <tr>
                                                       <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                                    </tr>
                                                 </tbody>
                                              </table>
                                              <h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">Your KYC details will expire soon</h2>
                                             
                                           </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <!-- device-row -->          
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                                              <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                                                 <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                                    <tbody>
                                                       <tr>
                                                          <td class="o_re o_bt-light" style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">&nbsp; </td>
                                                       </tr>
                                                    </tbody>
                                                 </table>
                                              </div>
                                              <p style="margin-top: 0px;margin-bottom: 0px;">We are pleased to inform that your KYC details will expire soon that you submitted previously. Please update your KYC details as soon as possible. Ignore if it''s already done.</p>
                                              </p>         
                                           </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                                              <p style="margin-top: 0px;margin-bottom: 0px;">Please click the following link on your browser to fill your KYC details</p>
                                           </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                                              <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                                 <tbody>
                                                    <tr>
                                                       <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">          <a class="o_text-white" href="##siteUrl##" style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">Click Here</a>           </td>
                                                    </tr>
                                                 </tbody>
                                              </table>
                                           </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          
         
          <!-- spacer -->    
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <!-- alert-primary -->         <!-- spacer -->    
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <!-- content -->    
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                                              <p style="margin-top: 0px;margin-bottom: 0px;">Thanks to be part of our company! We are all working towards a common goal and your contribution is an integral</p>
                                           </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <!-- spacer-lg -->    
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->      
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white" style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp; </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <!--[if mso]>
                               </td>
                            </tr>
                      </table>
                      <![endif]-->       
                   </td>
                </tr>
             </tbody>
          </table>
          <!-- footer-3cols -->    
          <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
             <tbody>
               
             </tbody>
          </table>
       </body>
    </html>','kyc Renewal',N'B36DC1E3-76C1-40E1-A64A-0F45EF301C4D')

	,('ClientKYCAlertMail','<!doctype html>   
     <html lang="en">
        <head>
           <meta charset="utf-8">
           <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
           <meta name="x-apple-disable-message-reformatting">
           <meta http-equiv="X-UA-Compatible" content="IE=edge">
           <title>Account New Sign-in</title>
           <style type="text/css">      a { text-decoration: none; outline: none; }      @media (max-width: 649px) {     .o_col-full { max-width: 100% !important; }     .o_col-half { max-width: 50% !important; }     .o_hide-lg { display: inline-block !important; font-size: inherit !important; max-height: none !important; line-height: inherit !important; overflow: visible !important; width: auto !important; visibility: visible !important; }     .o_hide-xs, .o_hide-xs.o_col_i { display: none !important; font-size: 0 !important; max-height: 0 !important; width: 0 !important; line-height: 0 !important; overflow: hidden !important; visibility: hidden !important; height: 0 !important; }     .o_xs-center { text-align: center !important; }     .o_xs-left { text-align: left !important; }     .o_xs-right { text-align: left !important; }     table.o_xs-left { margin-left: 0 !important; margin-right: auto !important; float: none !important; }     table.o_xs-right { margin-left: auto !important; margin-right: 0 !important; float: none !important; }     table.o_xs-center { margin-left: auto !important; margin-right: auto !important; float: none !important; }     h1.o_heading { font-size: 32px !important; line-height: 41px !important; }     h2.o_heading { font-size: 26px !important; line-height: 37px !important; }     h3.o_heading { font-size: 20px !important; line-height: 30px !important; }     .o_xs-py-md { padding-top: 24px !important; padding-bottom: 24px !important; }     .o_xs-pt-xs { padding-top: 8px !important; }     .o_xs-pb-xs { padding-bottom: 8px !important; }      }      @media screen {     @font-face {       font-family: Roboto;       font-style: normal;       font-weight: 400;       src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");       unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }     @font-face {       font-family: Roboto;       font-style: normal;       font-weight: 400;       src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");       unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }     @font-face {       font-family: Roboto;       font-style: normal;       font-weight: 700;       src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");       unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }     @font-face {       font-family: Roboto;       font-style: normal;       font-weight: 700;       src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");       unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }     .o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }     .o_heading, strong, b { font-weight: 700 !important; }     a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }      }    </style>
           <!--[if mso]>    
           <style>      table { border-collapse: collapse; }      .o_col { float: left; }    </style>
           <xml>
              <o:OfficeDocumentSettings>
                 <o:PixelsPerInch>96</o:PixelsPerInch>
              </o:OfficeDocumentSettings>
           </xml>
           <![endif]-->     
        </head>
        <body class="o_body o_bg-light" style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
           <!-- preview-text -->    
           <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
              <tbody>
                 <tr>
                    <td class="o_hide" align="center" style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">Email Summary (Hidden)</td>
                 </tr>
     			
              </tbody>
     		 
           </table>
           <!-- header-primary -->    
           <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
              <tbody>
                 <tr>
                    <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
     
                       <!--[if mso]>
                       <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                          <tbody>
                             <tr>
                                <td>
                                   <![endif]-->      
                                   
                                   <!--[if mso]>
                                </td>
                             </tr>
                       </table>
                       <![endif]-->				         
                    </td>
                 </tr>
              </tbody>
           </table>
           <!-- hero-white-icon-outline -->    
           <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
              <tbody>
                 <tr>
                    <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                       <!--[if mso]>
                       <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                          <tbody>
                             <tr>
                                <td>
                                   <![endif]-->      
                                   <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                      <tbody>
     								   <tr>
                                                                                         <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">                                                                                        
     																					<a href="#" target="_blank"><img src= "##CompanyLogo##" alt="" width="160" height="160" style="border-width:0; height:auto; display:block" align="left" /></a>                                                                                      </td>
                                                                                      </tr>
                                         <tr>
                                            <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
                                               <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                                                  <tbody>
                                                     <tr>
                                                        <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">      
     												   <img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">           </td>
                                                     </tr>
                                                     <tr>
                                                        <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                                     </tr>
                                                  </tbody>
                                               </table>
                                               <h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">Your KYC details has expired</h2>
                                              
                                            </td>
                                         </tr>
                                      </tbody>
                                   </table>
                                   <!--[if mso]>
                                </td>
                             </tr>
                       </table>
                       <![endif]-->       
                    </td>
                 </tr>
              </tbody>
           </table>
           <!-- device-row -->          
           <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
              <tbody>
                 <tr>
                    <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                       <!--[if mso]>
                       <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                          <tbody>
                             <tr>
                                <td>
                                   <![endif]-->      
                                   <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                      <tbody>
                                         <tr>
                                            <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                                               <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                                                  <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                                     <tbody>
                                                        <tr>
                                                           <td class="o_re o_bt-light" style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">&nbsp; </td>
                                                        </tr>
                                                     </tbody>
                                                  </table>
                                               </div>
                                               <p style="margin-top: 0px;margin-bottom: 0px;">We are pleased to inform that your KYC details has expired that you submitted previously. Please update your KYC details as soon as possible. Ignore if it is already done.</p>
                                               </p>         
                                            </td>
                                         </tr>
                                      </tbody>
                                   </table>
                                   <!--[if mso]>
                                </td>
                             </tr>
                       </table>
                       <![endif]-->       
                    </td>
                 </tr>
              </tbody>
           </table>
           <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
              <tbody>
                 <tr>
                    <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                       <!--[if mso]>
                       <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                          <tbody>
                             <tr>
                                <td>
                                   <![endif]-->      
                                   <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                      <tbody>
                                         <tr>
                                            <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                                               <p style="margin-top: 0px;margin-bottom: 0px;">Please click the following link on your browser to fill your KYC details</p>
                                            </td>
                                         </tr>
                                      </tbody>
                                   </table>
                                   <!--[if mso]>
                                </td>
                             </tr>
                       </table>
                       <![endif]-->       
                    </td>
                 </tr>
              </tbody>
           </table>
           <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
              <tbody>
                 <tr>
                    <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                       <!--[if mso]>
                       <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                          <tbody>
                             <tr>
                                <td>
                                   <![endif]-->      
                                   <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                      <tbody>
                                         <tr>
                                            <td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                                               <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                                  <tbody>
                                                     <tr>
                                                        <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">          <a class="o_text-white" href="##siteUrl##" style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">Click Here</a>           </td>
                                                     </tr>
                                                  </tbody>
                                               </table>
                                            </td>
                                         </tr>
                                      </tbody>
                                   </table>
                                   <!--[if mso]>
                                </td>
                             </tr>
                       </table>
                       <![endif]-->       
                    </td>
                 </tr>
              </tbody>
           </table>
           
          
           <!-- spacer -->    
           <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
              <tbody>
                 <tr>
                    <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                       <!--[if mso]>
                       <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                          <tbody>
                             <tr>
                                <td>
                                   <![endif]-->      
                                   <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                      <tbody>
                                         <tr>
                                            <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
                                         </tr>
                                      </tbody>
                                   </table>
                                   <!--[if mso]>
                                </td>
                             </tr>
                       </table>
                       <![endif]-->       
                    </td>
                 </tr>
              </tbody>
           </table>
           <!-- alert-primary -->         <!-- spacer -->    
           <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
              <tbody>
                 <tr>
                    <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                       <!--[if mso]>
                       <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                          <tbody>
                             <tr>
                                <td>
                                   <![endif]-->      
                                   <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                      <tbody>
                                         <tr>
                                            <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
                                         </tr>
                                      </tbody>
                                   </table>
                                   <!--[if mso]>
                                </td>
                             </tr>
                       </table>
                       <![endif]-->       
                    </td>
                 </tr>
              </tbody>
           </table>
           <!-- content -->    
           <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
              <tbody>
                 <tr>
                    <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                       <!--[if mso]>
                       <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                          <tbody>
                             <tr>
                                <td>
                                   <![endif]-->      
                                   <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                      <tbody>
                                         <tr>
                                            <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                                               <p style="margin-top: 0px;margin-bottom: 0px;">Thanks to be part of our company! We are all working towards a common goal and your contribution is an integral</p>
                                            </td>
                                         </tr>
                                      </tbody>
                                   </table>
                                   <!--[if mso]>
                                </td>
                             </tr>
                       </table>
                       <![endif]-->       
                    </td>
                 </tr>
              </tbody>
           </table>
           <!-- spacer-lg -->    
           <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
              <tbody>
                 <tr>
                    <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                       <!--[if mso]>
                       <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                          <tbody>
                             <tr>
                                <td>
                                   <![endif]-->      
                                   <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                      <tbody>
                                         <tr>
                                            <td class="o_bg-white" style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp; </td>
                                         </tr>
                                      </tbody>
                                   </table>
                                   <!--[if mso]>
                                </td>
                             </tr>
                       </table>
                       <![endif]-->       
                    </td>
                 </tr>
              </tbody>
           </table>
           <!-- footer-3cols -->    
           <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
              <tbody>
                 <tr>
                    <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center" style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
                       <div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                          <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                          <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                             <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights reserved</p>
                             <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944    - info@snovasys.com</p>
                             <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road London - TW4 6JQ</p>
                             <p style="margin-top: 0px;margin-bottom: 0px;">           Learn more at <a class="o_text-dark_light o_underline" href=##Registersite## style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a>           </p>
                          </div>
                       </div>
                       <!--[if mso]>
                    </td>
                    <td width="400" align="right" valign="top" style="padding:0px 8px;">
                       <![endif]-->        
                       <div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                          <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                          <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                             <p style="margin-top:0;margin-bottom:0">        <a class="o_text-dark_light" href="https://www.facebook.com/snovasys" style="text-decoration:none;outline:0;color:#a0a3ab"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png" width="36" height="36" alt="fb" style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>                          <a class="o_text-dark_light" href="https://twitter.com/snovasys" style="text-decoration:none;outline:0;color:#a0a3ab"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png" width="36" height="36" alt="tw" style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>                          <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/" style="text-decoration:none;outline:0;color:#a0a3ab"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36" height="36" alt="ig" style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>                          </p>
                          </div>
                       </div>
                    </td>
                 </tr>
              </tbody>
           </table>
        </body>
     </html>','KYC Expired Notification',N'C97C8358-D973-422B-9A32-752D3E6833CB')

     ,('KYCSubmissionTemplate','<!DOCTYPE html
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
     
             .button {
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
     
             .button1 {
                 background-color: #4CAF50;
             }
     
             /* Green */
             .button2 {
                 background-color: #eb4034;
             }
     
             /* Red */
             @@media only screen and (max-device-width: 480px) {
     
                 table[class=hide],
                 img[class=hide],
                 td[class=hide] {
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
                                                     <b>Dear ##FullName##,</b>
                                                     </p>
                                                     <p style="color:#262626; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif">We have successfully created account as a client.</p>
                                                     <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
         Please <a target="_blank" href="##SiteAddress##" style="color: #099">Click
             here</a> for KYC submission.</p>
                                                     
                                                     <p
                                                         style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                         Warm Regards, <br /> ##footerName## </p>
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
     
     </html>','KYC Submission',N'98612D47-E88D-4F8B-BFB0-F6AECF280C00')

	 ,('KYCDetailsSubmittedTemplate','<!DOCTYPE html
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
    
            .button {
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
    
            .button1 {
                background-color: #4CAF50;
            }
    
            /* Green */
            .button2 {
                background-color: #eb4034;
            }
    
            /* Red */
            @@media only screen and (max-device-width: 480px) {
    
                table[class=hide],
                img[class=hide],
                td[class=hide] {
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
                                                    <b>Hello,</b>
                                                    </p>
                                                    <p style="color:#262626; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif">##ClientName## successfully submitted KYC details.</p>
                                                    <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
        Please <a target="_blank" href="##SiteAddress##" style="color: #099">Click
            here</a> for futher process.</p>
                                                    
                                                    <p
                                                        style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                        Warm Regards, <br /> ##footerName## </p>
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
    
    </html>','KYC Submission',N'ED25EA28-0E8C-4420-B8A1-869594C7D9F2');

    MERGE INTO [dbo].[EmailTemplates] AS Target 
    USING (
	SELECT NEWID(),[EmailTemplateName],[EmailTemplate],[EmailSubject],[EmailTemplateReferenceId],GETUTCDATE(),@UserId,@CompanyId,C.Id
	FROM
	(SELECT [EmailTemplateName],[EmailTemplate]
	 ,[EmailSubject],[EmailTemplateReferenceId]
	 FROM @Template
	 ) T
    INNER JOIN Client C On 1 = 1
	WHERE CompanyId = @CompanyId 
    )
    AS Source ([Id], [EmailTemplateName], [EmailTemplate],[EmailSubject],[EmailTemplateReferenceId],[CreatedDateTime], [CreatedByUserId],[CompanyId],[ClientId]) 
    ON Target.Id = Source.Id  
    WHEN MATCHED THEN 
    UPDATE SET [EmailTemplateName] = Source.[EmailTemplateName],
               [EmailTemplate] = Source.[EmailTemplate],
               [EmailSubject] = Source.[EmailSubject],
               [ClientId] = Source.[ClientId],
               [EmailTemplateReferenceId] = Source.[EmailTemplateReferenceId],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId] = Source.[CompanyId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], [EmailTemplateName], [EmailTemplate], [EmailSubject], [ClientId], [EmailTemplateReferenceId], [CreatedDateTime], [CreatedByUserId], [CompanyId]) 
    VALUES ([Id], [EmailTemplateName], [EmailTemplate], [EmailSubject], [ClientId], [EmailTemplateReferenceId], [CreatedDateTime], [CreatedByUserId], [CompanyId]);

    MERGE INTO [dbo].[HtmlTags] AS Target 
	USING ( VALUES
	        (NEWID(), N'##CompanyName##',N'D2675610-3BEA-428C-9515-D5726160BD6D','This is the client company name', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##siteUrl##',N'D2675610-3BEA-428C-9515-D5726160BD6D','This is client registered company URL to login', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##Name##',N'D2675610-3BEA-428C-9515-D5726160BD6D','This is used to show client firstname and lastname', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##UserName##',N'D2675610-3BEA-428C-9515-D5726160BD6D','This is the client email which is used sending any emails or for any other purpose', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##Password##',N'D2675610-3BEA-428C-9515-D5726160BD6D','This is the client default password to login intially', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##CompanyRegistrationLogo##',N'D2675610-3BEA-428C-9515-D5726160BD6D','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   --ClientKYCAltert
		   ,(NEWID(), N'##siteUrl##',N'C97C8358-D973-422B-9A32-752D3E6833CB','This is client registered company URL to login', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyName##',N'C97C8358-D973-422B-9A32-752D3E6833CB','This is the client company name', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'C97C8358-D973-422B-9A32-752D3E6833CB','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   --KYCRemidMail
		   ,(NEWID(), N'##siteUrl##',N'B36DC1E3-76C1-40E1-A64A-0F45EF301C4D','This is client registered company URL to login', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyName##',N'B36DC1E3-76C1-40E1-A64A-0F45EF301C4D','This is the client company name', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'B36DC1E3-76C1-40E1-A64A-0F45EF301C4D','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
	        ) 
	AS Source ([Id], [HtmlTagName],[HtmlTemplateId],[Description], [CompanyId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [HtmlTagName] = Source.[HtmlTagName],
	           [HtmlTemplateId] = Source.[HtmlTemplateId],
	           [Description] = Source.[Description],
	           [CreatedByUserId] = Source.[CreatedByUserId],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [InActiveDateTime] = Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET AND Source.[HtmlTemplateId] IS NOT NULL THEN 
	INSERT ([Id], [HtmlTagName],[HtmlTemplateId],[Description], [CompanyId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]) 
	VALUES ([Id], [HtmlTagName],[HtmlTemplateId],[Description], [CompanyId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]);

   MERGE INTO [dbo].[HtmlTags] AS Target 
	USING ( VALUES
	        (NEWID(), N'##AddressLine1##',N'98612D47-E88D-4F8B-BFB0-F6AECF280C00','This is the client address line one of their locality', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##AddressLine2##',N'98612D47-E88D-4F8B-BFB0-F6AECF280C00','This is the client address line two of their locality', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##BusinessEmail##',N'98612D47-E88D-4F8B-BFB0-F6AECF280C00','This is the business email which is used in proforma invoice', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##BusinessNumber##',N'98612D47-E88D-4F8B-BFB0-F6AECF280C00','This is the business number which is used in proforma invoice', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##CompanyName##',N'98612D47-E88D-4F8B-BFB0-F6AECF280C00','This is the client company', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##CompanyWebsite##',N'98612D47-E88D-4F8B-BFB0-F6AECF280C00','This is the client website which belogs to client organization', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##Email##',N'98612D47-E88D-4F8B-BFB0-F6AECF280C00','This is the client email which is used sending any emails or for any other purpose', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##GstNumber##',N'98612D47-E88D-4F8B-BFB0-F6AECF280C00','his is the GST number which is used in proforma invoice', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##MobileNo##',N'98612D47-E88D-4F8B-BFB0-F6AECF280C00','This the primary contact number which is used contact purpose and sending SMS', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##Zipcode##',N'98612D47-E88D-4F8B-BFB0-F6AECF280C00','This is the client zip code of their locality', @CompanyId, GETDATE(), @UserId, NULL)
	        ) 
	AS Source ([Id], [HtmlTagName],[HtmlTemplateId],[Description], [CompanyId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [HtmlTagName] = Source.[HtmlTagName],
	           [HtmlTemplateId] = Source.[HtmlTemplateId],
	           [Description] = Source.[Description],
	           [CreatedByUserId] = Source.[CreatedByUserId],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [InActiveDateTime] = Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [HtmlTagName],[HtmlTemplateId],[Description], [CompanyId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]) 
	VALUES ([Id], [HtmlTagName],[HtmlTemplateId],[Description], [CompanyId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]);

        MERGE INTO [dbo].[RoleFeature] AS Target 
        USING ( VALUES
            (NEWID(), @RoleId, N'6F4BDCDC-0C35-4E93-BA29-F3028E27CBD2', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'5661A6BD-01CE-441F-9FD8-42BD7B64E06E', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'562FA0CA-B2F8-4409-8DAE-9FAE4452D8F8', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'C29A9771-221F-4735-8F94-8CEBCB166B29', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'9118FCEE-C6C6-456A-A985-D87C971FC59F', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'625ADDB4-955D-4765-B598-9A062CFF8C3C', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'96EADE43-EDAC-4775-BB75-861670E75EB3', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'BFC7E7FC-D279-4A7E-86C5-668ED8EBA996', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'9740C489-A3F3-4065-8748-07A42759D159', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'51AFE938-42A3-4751-8A9C-5EBDB00F3713', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'0DB33301-CA08-4816-A828-2BB0E4DECE99', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'FA8279C1-4AE8-4F73-B0E9-28F338D82BDC', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'86C43591-3484-46FE-ADA2-390BB74FA2DE', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'886C95D6-541C-47E9-859E-0E37665ED818', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'552AF980-1F38-47E3-9614-50B7030C31C1', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'C23ED0F6-9569-429B-8B59-1D5979EAA3AE', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'4B53DE09-5A6D-4556-8C85-AEC44CE00E9F', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
        )
        AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
        ON Target.[RoleId] = Source.[RoleId] AND Target.[FeatureId] = Source.[FeatureId]
        WHEN MATCHED THEN 
        UPDATE SET [RoleId] = Source.[RoleId],
                   [FeatureId] = Source.[FeatureId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
        VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);
END
GO