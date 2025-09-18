CREATE PROCEDURE [dbo].[Marker413]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN
    UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Draft for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the purchase contract draft for your next action.<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
   <!-- footer-3cols -->
</body>

</html>' WHERE EmailTemplateName='ShareDraftContractToSellerTemplate'
UPDATE EmailTemplates SET EmailTemplate = '<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Draft for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the sales contract draft for your next action.<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName = 'ShareDraftContractToBuyerTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Signature for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the sales contract for your signatures.<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='DraftSignatureEmailToBuyerTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
       <html lang="en">
       
       <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
          <meta name="x-apple-disable-message-reformatting">
          <meta http-equiv="X-UA-Compatible" content="IE=edge">
          <title>Account New Sign-in</title>
          <style type="text/css">
             a {
                text-decoration: none;
                outline: none;
             }
       
             @media (max-width: 649px) {
                .o_col-full {
                   max-width: 100% !important;
                }
       
                .o_col-half {
                   max-width: 50% !important;
                }
       
                .o_hide-lg {
                   display: inline-block !important;
                   font-size: inherit !important;
                   max-height: none !important;
                   line-height: inherit !important;
                   overflow: visible !important;
                   width: auto !important;
                   visibility: visible !important;
                }
       
                .o_hide-xs,
                .o_hide-xs.o_col_i {
                   display: none !important;
                   font-size: 0 !important;
                   max-height: 0 !important;
                   width: 0 !important;
                   line-height: 0 !important;
                   overflow: hidden !important;
                   visibility: hidden !important;
                   height: 0 !important;
                }
       
                .o_xs-center {
                   text-align: center !important;
                }
       
                .o_xs-left {
                   text-align: left !important;
                }
       
                .o_xs-right {
                   text-align: left !important;
                }
       
                table.o_xs-left {
                   margin-left: 0 !important;
                   margin-right: auto !important;
                   float: none !important;
                }
       
                table.o_xs-right {
                   margin-left: auto !important;
                   margin-right: 0 !important;
                   float: none !important;
                }
       
                table.o_xs-center {
                   margin-left: auto !important;
                   margin-right: auto !important;
                   float: none !important;
                }
       
                h1.o_heading {
                   font-size: 32px !important;
                   line-height: 41px !important;
                }
       
                h2.o_heading {
                   font-size: 26px !important;
                   line-height: 37px !important;
                }
       
                h3.o_heading {
                   font-size: 20px !important;
                   line-height: 30px !important;
                }
       
                .o_xs-py-md {
                   padding-top: 24px !important;
                   padding-bottom: 24px !important;
                }
       
                .o_xs-pt-xs {
                   padding-top: 8px !important;
                }
       
                .o_xs-pb-xs {
                   padding-bottom: 8px !important;
                }
             }
       
             @media screen {
                @font-face {
                   font-family: Roboto;
                   font-style: normal;
                   font-weight: 400;
                   src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
                   unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
                }
       
                @font-face {
                   font-family: Roboto;
                   font-style: normal;
                   font-weight: 400;
                   src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
                   unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
                }
       
                @font-face {
                   font-family: Roboto;
                   font-style: normal;
                   font-weight: 700;
                   src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
                   unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
                }
       
                @font-face {
                   font-family: Roboto;
                   font-style: normal;
                   font-weight: 700;
                   src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
                   unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
                }
       
                .o_sans,
                .o_heading {
                   font-family: "Roboto", sans-serif !important;
                }
       
                .o_heading,
                strong,
                b {
                   font-weight: 700 !important;
                }
       
                a[x-apple-data-detectors] {
                   color: inherit !important;
                   text-decoration: none !important;
                }
             }
          </style>
       </head>
       
       <body class="o_body o_bg-light"
          style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
          <!-- preview-text -->
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_hide" align="center"
                      style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
                      Email Summary (Hidden)</td>
                </tr>
             </tbody>
          </table>
          <!-- header-primary -->
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
                      style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
                      <!--[if mso]>
                             <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                <tbody>
                                   <tr>
                                      <td>
                                         <![endif]-->
                      <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                         style="max-width: 632px;margin: 0 auto;">
                         <tbody>
                            <tr>
                               <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                                  style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                                  <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                        style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                           width="136" height="36"
                                           style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
          <!-- hero-white-icon-outline -->
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center"
                      style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                             <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                <tbody>
                                   <tr>
                                      <td>
                                         <![endif]-->
                      <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                         style="max-width: 632px;margin: 0 auto;">
                         <tbody>
                            <tr>
                               <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                                  style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                                  <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                                     <tbody>
                                        <tr>
                                           <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                              align="center"
                                              style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                              <img
                                                 src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                                 width="48" height="48" alt=""
                                                 style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                           </td>
                                        </tr>
                                        <tr>
                                           <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <h2 class="o_heading o_text-dark o_mb-xxs"
                                     style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                                     Signature for ##ContractId##
       </h2>
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
                   <td class="o_bg-light o_px-xs" align="center"
                      style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                             <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                <tbody>
                                   <tr>
                                      <td>
                                         <![endif]-->
                      <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                         style="max-width: 632px;margin: 0 auto;">
                         <tbody>
                            <tr>
                               <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                  style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                                  <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                                     <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                        <tbody>
                                           <tr>
                                              <td class="o_re o_bt-light"
                                                 style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                                 &nbsp; </td>
                                           </tr>
                                        </tbody>
                                     </table>
                                  </div>
                                  <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                                     role="presentation" style="max-width: 632px;margin: 0 auto;">
                                     <tbody>
                                        <tr>
                                           <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                              style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                              Ref:
                                           </td>
                                           <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                              style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                              ##ContractId##
                                           </td>
                                        </tr>
                                        <tr>
                                           <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                              style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                              Commodity:
                                           </td>
                                           <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                              style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                              ##Commodity##
                                           </td>
                                        </tr>
                                        <tr>
                                           <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                              style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                              Qty:
                                           </td>
                                           <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                              style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                              ##Quantity##
                                           </td>
                                        </tr>
                                     </tbody>
                                  </table>
                                  <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the purchase contract draft acceptance from Seller / Commodity Brokers side for your next action on signatures and/ stamping.<br>
       Thank you.</p>
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
                   <td class="o_bg-light o_px-xs" align="center"
                      style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                             <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                <tbody>
                                   <tr>
                                      <td>
                                         <![endif]-->
                      <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                         style="max-width: 632px;margin: 0 auto;">
                         <tbody>
                            <tr>
                               <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                  style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                                  <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
                   <td class="o_bg-light o_px-xs" align="center"
                      style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                             <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                <tbody>
                                   <tr>
                                      <td>
                                         <![endif]-->
                      <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                         style="max-width: 632px;margin: 0 auto;">
                         <tbody>
                            <tr>
                               <td class="o_bg-white o_px-md o_py-xs" align="center"
                                  style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                                  <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                     <tbody>
                                        <tr>
                                           <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                              <a class="o_text-white" href="##siteUrl##"
                                                 style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                                 contract</a> </td>
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
       
          <!-- spacer-lg -->
          <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
             <tbody>
                <tr>
                   <td class="o_bg-light o_px-xs" align="center"
                      style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                      <!--[if mso]>
                             <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                <tbody>
                                   <tr>
                                      <td>
                                         <![endif]-->
                      <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                         style="max-width: 632px;margin: 0 auto;">
                         <tbody>
                            <tr>
                               <td class="o_bg-white"
                                  style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
       </body>
       
       </html>' WHERE EmailTemplateName = 'DraftSignatureEmailToSellerTemplate'
       UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Draft approve for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the sales contract draft acceptance from Buyer / Commodity Broker for your next action.<br>Comments: ##Comments##<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='DraftSaleContractApproveEmailToSGTraderTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Draft approve for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the purchase contract draft for your next action.<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='DraftPurchaseContractApproveEmailToSGTraderTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Draft reject for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the purchase contract draft rejection from Seller / Commodity Brokers side for your next action.<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='DraftPurchaseContractRejectEmailToSGTraderTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Draft reject for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the sales contract draft rejection from Buyer / Commodity Broker for your next action.<br>Comments: ##Comments##<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='DraftSaleContractRejectEmailToSGTraderTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Seller signature acceptance for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the seller signature for your next action<br>Comments: ##Comments##<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='SellerSignatureAcceptEmailTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Buyer signature acceptance for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the buyer signature for your next action<br>Comments: ##Comments##<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='BuyerSignatureAcceptEmailTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Seller signature rejection for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the signature rejection for your next action
                           <br>Comments: ##Comments##<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='SellerSignatureRejectEmailTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Buyer signature rejection for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the signature rejection for your next action
                           <br>Comments: ##Comments##<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='BuyerSignatureRejectEmailTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Signature for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the purchase contract for your signatures.<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='SGTraderSignatureEmailForPurchaseContractTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Signature for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the sales contract for your signatures.<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplate ='SGTraderSignatureEmailForSellerContractTemplate' 
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              SG Trader signature acceptance for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the signature acceptance for your next action
                           <br>Comments: ##Comments##<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='SGTraderSignatureAcceptEmailBySellerTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              SG Trader signature acceptance for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the signature acceptance for your next action
                           <br>Comments: ##Comments##<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='SGTraderSignatureAcceptEmailByBuyerTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              SG Trader signature rejection for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the signature rejection for your next action
                           <br>Comments: ##Comments##<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='SGTraderSignatureRejectEmailBySellerTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              SG Trader signature rejection for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the signature rejection for your next action
                           <br>Comments: ##Comments##<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='SGTraderSignatureRejectEmailByBuyerTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Seller signature verification by SGTrader for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please verify the seller signature for your next action.<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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

</body>

</html>' WHERE EmailTemplateName ='SellerSignatureVerificationMailToSgTraderTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Buyer signature verification by SGTrader for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please verify the buyer signature for your next action.<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='BuyerSignatureVerificationMailToSgTraderTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              SGTrader signature verification by seller for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please verify the SgTrader signature for your next action.<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='SgTraderSignatureVerificationMailToSellerTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              SGTrader signature verification by buyer for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please verify the SgTrader signature for your next action.<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName = 'SgTraderSignatureVerificationMailToBuyerTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Account New Sign-in</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Purchase contract sealed for ##ContractId##</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Ref:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##ContractId##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Commodity:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##Commodity##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">Qty:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">##Quantity##</td></tr></tbody></table><p style="margin-top:0;margin-bottom:0">Hello,<br>Please find the contract is sealed and ready for your next action Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Click on link for further details</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View contract</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='PurchaseContractSealingEmailTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Account New Sign-in</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Sales contract sealed for ##ContractId##</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Ref:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##ContractId##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Commodity:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##Commodity##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">Qty:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">##Quantity##</td></tr></tbody></table><p style="margin-top:0;margin-bottom:0">Hello,<br>Please find the contract is sealed and ready for your next action Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Click on link for further details</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View contract</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='SellerContractSealingEmailTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Account New Sign-in</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Invoice Acceptance - ##InvoiceNo## for ##ContractId##</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><p style="margin-top:0;margin-bottom:0">Hello,<br>Please Verify the invoice for your next action.<br>Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Click on link for further details</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View invoice</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='ShareInvoiceToContracterEmailTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Account New Sign-in</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Invoice Accepted - ##InvoiceNo## for ##ContractId##</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><p style="margin-top:0;margin-bottom:0">Hello,<br>Please Verify the invoice for your next action.<br>Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Click on link for further details</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View invoice</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='InvoiceAcceptanceByContracterEmailTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Account New Sign-in</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Invoice Generated - ##InvoiceNo## for ##ContractId##</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><p style="margin-top:0;margin-bottom:0">Hello,<br>Please Verify the invoice for your next action.<br>Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Click on link for further details</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View invoice</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='InvoiceAcceptanceBySgtraderEmailTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Account New Sign-in</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Invoice Rejected - ##InvoiceNo## for ##ContractId##</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><p style="margin-top:0;margin-bottom:0">Hello,<br>Please Verify the invoice for your next action.<br>Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Click on link for further details</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View invoice</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='InvoiceRejectanceByContracterEmailTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Account New Sign-in</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Invoice Rejected - ##InvoiceNo## for ##ContractId##</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><p style="margin-top:0;margin-bottom:0">Hello,<br>Please Verify the invoice for your next action.<br>Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Click on link for further details</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View invoice</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='InvoiceRejectanceBySgtraderEmailTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              SwitchBl contract accept/reject
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please accept/reject the switchbl contract for your next action.<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='SwitchBlContractAcceptOrRejectMailToBuyerTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              SwitchBL contract is accepted by ##UserName##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the swichbl buyer accepted contract for your next action.<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='SwitchBlBuyerAcceptenceMailToSgTraderTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              SwitchBL contract is rejected by ##UserName##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the swichbl buyer rejected contract for your next action.<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='SwitchBlBuyerRejectionMailToSgTraderTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              SwitchBl vessel owner contract for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>For the contract ##ContractId## dated ##ContractSealedDateTime## for ##Commodity## of total quatity ##Quantity## ##MeasurementUnit##,Please find the draft BL attachment for your review.<br>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='SwitchBlContractMailToVesselOwnerTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <meta name="x-apple-disable-message-reformatting">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <title>Account New Sign-in</title>
   <style type="text/css">
      a {
         text-decoration: none;
         outline: none;
      }

      @media (max-width: 649px) {
         .o_col-full {
            max-width: 100% !important;
         }

         .o_col-half {
            max-width: 50% !important;
         }

         .o_hide-lg {
            display: inline-block !important;
            font-size: inherit !important;
            max-height: none !important;
            line-height: inherit !important;
            overflow: visible !important;
            width: auto !important;
            visibility: visible !important;
         }

         .o_hide-xs,
         .o_hide-xs.o_col_i {
            display: none !important;
            font-size: 0 !important;
            max-height: 0 !important;
            width: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
            visibility: hidden !important;
            height: 0 !important;
         }

         .o_xs-center {
            text-align: center !important;
         }

         .o_xs-left {
            text-align: left !important;
         }

         .o_xs-right {
            text-align: left !important;
         }

         table.o_xs-left {
            margin-left: 0 !important;
            margin-right: auto !important;
            float: none !important;
         }

         table.o_xs-right {
            margin-left: auto !important;
            margin-right: 0 !important;
            float: none !important;
         }

         table.o_xs-center {
            margin-left: auto !important;
            margin-right: auto !important;
            float: none !important;
         }

         h1.o_heading {
            font-size: 32px !important;
            line-height: 41px !important;
         }

         h2.o_heading {
            font-size: 26px !important;
            line-height: 37px !important;
         }

         h3.o_heading {
            font-size: 20px !important;
            line-height: 30px !important;
         }

         .o_xs-py-md {
            padding-top: 24px !important;
            padding-bottom: 24px !important;
         }

         .o_xs-pt-xs {
            padding-top: 8px !important;
         }

         .o_xs-pb-xs {
            padding-bottom: 8px !important;
         }
      }

      @media screen {
         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 400;
            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
         }

         @font-face {
            font-family: Roboto;
            font-style: normal;
            font-weight: 700;
            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
         }

         .o_sans,
         .o_heading {
            font-family: "Roboto", sans-serif !important;
         }

         .o_heading,
         strong,
         b {
            font-weight: 700 !important;
         }

         a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
         }
      }
   </style>
</head>

<body class="o_body o_bg-light"
   style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
   <!-- preview-text -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_hide" align="center"
               style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">
               Email Summary (Hidden)</td>
         </tr>
      </tbody>
   </table>
   <!-- header-primary -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
   <!-- hero-white-icon-outline -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 5px;">
                           <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                       align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                       <img
                                          src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png"
                                          width="48" height="48" alt=""
                                          style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                 </tr>
                              </tbody>
                           </table>
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                              Contract cancel for ##ContractId##
</h2>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
                                 <tbody>
                                    <tr>
                                       <td class="o_re o_bt-light"
                                          style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">
                                          &nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                           <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0"
                              role="presentation" style="max-width: 632px;margin: 0 auto;">
                              <tbody>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Ref:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##ContractId##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Commodity:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Commodity##
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##Quantity##  ##MeasurementUnit##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the purchase contract cancellation from SGTrader for your next action.<br>
                           Comments : ##Comments## <br/>
Thank you.</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;">Click on link for further details</p>
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
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white o_px-md o_py-xs" align="center"
                           style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
                           <table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
                              <tbody>
                                 <tr>
                                    <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                       <a class="o_text-white" href="##siteUrl##"
                                          style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">View
                                          contract</a> </td>
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

   <!-- spacer-lg -->
   <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
         <tr>
            <td class="o_bg-light o_px-xs" align="center"
               style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
               <!--[if mso]>
                      <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                         <tbody>
                            <tr>
                               <td>
                                  <![endif]-->
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-white"
                           style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp;
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
</body>

</html>' WHERE EmailTemplateName ='SGTraderContractCancelEmailTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Account New Sign-in</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Vessel Contract for ##RFQId##</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Ref:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##ContractId##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Commodity:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##Commodity##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">Qty:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">##Quantity##</td></tr></tbody></table><p style="margin-top:0;margin-bottom:0">Hello,<br>Please find the vessel contract for your next action.<br>Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Click on link for further details</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View contract</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='RFQToVesselContractDraftTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Account New Sign-in</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Signature for acceptance of Vessel Contract(##ContractId##)</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Ref:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##ContractId##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Commodity:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##Commodity##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">Qty:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">##Quantity##</td></tr></tbody></table><p style="margin-top:0;margin-bottom:0">Hello,<br>Please find the signature for your next action<br>Thank you.<br>Comment: ##Comments##</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Click on link for further details</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View contract</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='DraftVesselContractSignatureAcceptanceForShipBrokerorVesselOwnerTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Account New Sign-in</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Signature for acceptance of Vessel Contract(##ContractId##)</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Ref:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##ContractId##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Commodity:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##Commodity##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">Qty:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">##Quantity##</td></tr></tbody></table><p style="margin-top:0;margin-bottom:0">Hello,<br>Please find the signature for your next action<br>Thank you.<br>Comment: ##Comments##</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Click on link for further details</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View contract</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='DraftVesselContractSignatureAcceptanceForSGTraderTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Account New Sign-in</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Vessel Contract Accepted for ##ContractId##</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Ref:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##ContractId##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Commodity:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##Commodity##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">Qty:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">##Quantity##</td></tr></tbody></table><p style="margin-top:0;margin-bottom:0">Hello,<br>Please find the vessel contract for your next action.<br>Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Click on link for further details</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View contract</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='DraftVesselContractAcceptedTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Account New Sign-in</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Vessel Owner / Ship Broker signature verification by SGTrader for ##ContractId##</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Ref:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##ContractId##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Commodity:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##Commodity##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">Qty:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">##Quantity##</td></tr></tbody></table><p style="margin-top:0;margin-bottom:0">Hello,<br>Please verify the Vessel Owner / Ship Broker signature for your next action.<br>Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Click on link for further details</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View contract</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='VesselOwnerorShipBrokerSignatureVerificationMailToSgTraderTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Account New Sign-in</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Signature accepted for Vessel Contract(##ContractId##) By Ship Broker / Vessel Owner</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Ref:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##ContractId##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Commodity:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##Commodity##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">Qty:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">##Quantity##</td></tr></tbody></table><p style="margin-top:0;margin-bottom:0">Hello,<br>Please find the signature for your next action<br>Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Click on link for further details</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View contract</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='VesselContractSignatureAcceptByShipBrokerorVesselOwnerTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Account New Sign-in</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Signature rejected By Ship Broker / Vessel Owner for Vessel Contract(##ContractId##)</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Ref:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##ContractId##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Commodity:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##Commodity##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">Qty:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">##Quantity##</td></tr></tbody></table><p style="margin-top:0;margin-bottom:0">Hello,<br>Please find the signature for your next action<br>Comments: ##Comments##<br>Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Click on link for further details</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View contract</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='VesselContractSignatureRejectByShipBrokerorVesselOwnerTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Account New Sign-in</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Vessel contract sealed for ##ContractId##</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Ref:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##ContractId##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">Commodity:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px">##Commodity##</td></tr><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">Qty:</td><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-bottom:16px">##Quantity##</td></tr></tbody></table><p style="margin-top:0;margin-bottom:0">Hello,<br>Please find the contract is sealed and ready for your next action Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Click on link for further details</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View contract</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='VesselContractSealingEmailTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>RFQ Request</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style><!--[if mso]><style>table{border-collapse:collapse}.o_col{float:left}</style><xml><o:officedocumentsettings><o:pixelsperinch>96</o:pixelsperinch></o:officedocumentsettings></xml><![endif]--></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:64px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Q88 shared By ##UserName##(Trader)</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="left" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><p style="margin-top:0;margin-bottom:0">Hello ,</p><br><p style="margin-top:0;margin-bottom:0">Q88 shared by ##UserName##</p><br><p style="margin-top:0;margin-bottom:0">Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Please click the view Q88 for further detail.</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View Q88</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='Q88ShareTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>RFQ Request</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style><!--[if mso]><style>table{border-collapse:collapse}.o_col{float:left}</style><xml><o:officedocumentsettings><o:pixelsperinch>96</o:pixelsperinch></o:officedocumentsettings></xml><![endif]--></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:64px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Q88 Accepted For ##RFQId##</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="left" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><p style="margin-top:0;margin-bottom:0">Hello ,</p><br><p style="margin-top:0;margin-bottom:0">Q88 Accepted for ##RFQId## by ##UserName##</p><br><p style="margin-top:0;margin-bottom:0">Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><</body></html>' WHERE EmailTemplateName ='Q88AcceptTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>RFQ Request</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style><!--[if mso]><style>table{border-collapse:collapse}.o_col{float:left}</style><xml><o:officedocumentsettings><o:pixelsperinch>96</o:pixelsperinch></o:officedocumentsettings></xml><![endif]--></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:64px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Q88 Rejected For ##RFQId##</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="left" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><p style="margin-top:0;margin-bottom:0">Hello ,</p><br><p style="margin-top:0;margin-bottom:0">Q88 Rejected For ##RFQId## by ##UserName##</p><p style="margin-top:0;margin-bottom:0">Rejected comments: ##Comment##</p><br><p style="margin-top:0;margin-bottom:0">Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='Q88RejectTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>RFQ Request</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style><!--[if mso]><style>table{border-collapse:collapse}.o_col{float:left}</style><xml><o:officedocumentsettings><o:pixelsperinch>96</o:pixelsperinch></o:officedocumentsettings></xml><![endif]--></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:64px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">RFQ Accepted By ##UserName##(Trader)</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="left" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><p style="margin-top:0;margin-bottom:0">Hello ,</p><br><p style="margin-top:0;margin-bottom:0">RFQ Id: ##RFQId##</p><p style="margin-top:0;margin-bottom:0">Commodity: ##Commodity##</p><p style="margin-top:0;margin-bottom:0">Quantity: ##Quantity##</p><br><p style="margin-top:0;margin-bottom:0">Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Please click the view RFQ details for further detail.</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View RFQ</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='RFQAccepetedByTraderTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>RFQ Request</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style><!--[if mso]><style>table{border-collapse:collapse}.o_col{float:left}</style><xml><o:officedocumentsettings><o:pixelsperinch>96</o:pixelsperinch></o:officedocumentsettings></xml><![endif]--></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:64px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">RFQ Rejected By ##UserName##(Trader)</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="left" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><p style="margin-top:0;margin-bottom:0">Hello ,</p><br><p style="margin-top:0;margin-bottom:0">RFQ Id: ##RFQId##</p><p style="margin-top:0;margin-bottom:0">Commodity: ##Commodity##</p><p style="margin-top:0;margin-bottom:0">Quantity: ##Quantity##</p><br><p style="margin-top:0;margin-bottom:0">Rejected Comments: ##Comment##</p><br><p style="margin-top:0;margin-bottom:0">Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Please click the view RFQ details for further detail.</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View RFQ</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='RFQRejectedByTraderTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>RFQ Request</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style><!--[if mso]><style>table{border-collapse:collapse}.o_col{float:left}</style><xml><o:officedocumentsettings><o:pixelsperinch>96</o:pixelsperinch></o:officedocumentsettings></xml><![endif]--></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:64px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">RFQ Updated By ##TraderName## Trader</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="left" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><p style="margin-top:0;margin-bottom:0">Hello ,</p><br><p style="margin-top:0;margin-bottom:0">RFQ Id: ##RFQId##</p><p style="margin-top:0;margin-bottom:0">Commodity: ##Commodity##</p><p style="margin-top:0;margin-bottom:0">Quantity: ##Quantity##</p><br><p style="margin-top:0;margin-bottom:0">Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Please click the view RFQ details for further detail.</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View RFQ</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='RFQUpdateByTraderTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>RFQ Request</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style><!--[if mso]><style>table{border-collapse:collapse}.o_col{float:left}</style><xml><o:officedocumentsettings><o:pixelsperinch>96</o:pixelsperinch></o:officedocumentsettings></xml><![endif]--></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:64px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">RFQ Accepted By ##UserName##(Vessel Owner/Ship Broker)</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="left" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><p style="margin-top:0;margin-bottom:0">Hello ,</p><br><p style="margin-top:0;margin-bottom:0">RFQ Id: ##RFQId##</p><p style="margin-top:0;margin-bottom:0">Commodity: ##Commodity##</p><p style="margin-top:0;margin-bottom:0">Quantity: ##Quantity##</p><br><p style="margin-top:0;margin-bottom:0">Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Please click the view RFQ details for further detail.</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View RFQ</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='RFQAcceptedByClientTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>RFQ Request</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style><!--[if mso]><style>table{border-collapse:collapse}.o_col{float:left}</style><xml><o:officedocumentsettings><o:pixelsperinch>96</o:pixelsperinch></o:officedocumentsettings></xml><![endif]--></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:64px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">RFQ Filled By ##ClientName## (Vessel Owner / Ship Broker)</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="left" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><p style="margin-top:0;margin-bottom:0">Hello ,</p><br><p style="margin-top:0;margin-bottom:0">RFQ Id: ##RFQId##</p><p style="margin-top:0;margin-bottom:0">Commodity: ##Commodity##</p><p style="margin-top:0;margin-bottom:0">Quantity: ##Quantity##</p><br><p style="margin-top:0;margin-bottom:0">Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Please click the view RFQ details for further detail.</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View RFQ</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='RFQFilledTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>RFQ Request</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style><!--[if mso]><style>table{border-collapse:collapse}.o_col{float:left}</style><xml><o:officedocumentsettings><o:pixelsperinch>96</o:pixelsperinch></o:officedocumentsettings></xml><![endif]--></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:64px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">RFQ Updated By ##ClientName## (Vessel Owner / Ship Broker)</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="left" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><p style="margin-top:0;margin-bottom:0">Hello ,</p><br><p style="margin-top:0;margin-bottom:0">RFQ Id: ##RFQId##</p><p style="margin-top:0;margin-bottom:0">Commodity: ##Commodity##</p><p style="margin-top:0;margin-bottom:0">Quantity: ##Quantity##</p><br><p style="margin-top:0;margin-bottom:0">Thank you.</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Please click the view RFQ details for further detail.</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View RFQ</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table></body></html>' WHERE EmailTemplateName ='RFQUpdateByClientTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no"><meta name="x-apple-disable-message-reformatting"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>RFQ Request</title><style type="text/css">a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style><!--[if mso]><style>table{border-collapse:collapse}.o_col{float:left}</style><xml><o:officedocumentsettings><o:pixelsperinch>96</o:pixelsperinch></o:officedocumentsettings></xml><![endif]--></head><body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px"><p style="margin-top:0;margin-bottom:0"><a class="o_text-white" style="text-decoration:none;outline:0;color:#fff"><img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:64px"><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px"><img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></td></tr><tr><td style="font-size:24px;line-height:24px;height:24px">&nbsp;</td></tr></tbody></table><h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">RFQ Request</h2></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="left" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><div class="o_px-xs" style="padding-left:8px;padding-right:8px"><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;</td></tr></tbody></table></div><p style="margin-top:0;margin-bottom:0">Hello ,</p><br><p style="margin-top:0;margin-bottom:0">RFQ Id: ##RFQId##</p><p style="margin-top:0;margin-bottom:0">Commodity: ##Commodity##</p><p style="margin-top:0;margin-bottom:0">Quantity: ##Quantity##</p></p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px"><p style="margin-top:0;margin-bottom:0">Please click the view RFQ details for further detail.</p></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px"><table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px"><a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View RFQ</a></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></table><table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px"><!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]--><table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto"><tbody><tr><td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;</td></tr></tbody></table><!--[if mso]><![endif]--></td></tr></tbody></body></html>' WHERE EmailTemplateName ='RFQRequestTemplate'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>   
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
                                                   <td class="o_bg-white" style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp; </td>
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
                 
               </body>
            </html>' WHERE EmailTemplateName ='ClientRegistrationMail'
           UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="x-apple-disable-message-reformatting">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>XP1Request</title>
    <style type="text/css">
      a {
        text-decoration: none;
        outline: none;
      }

      @media (max-width: 649px) {
        .o_col-full {
          max-width: 100% !important;
        }

        .o_col-half {
          max-width: 50% !important;
        }

        .o_hide-lg {
          display: inline-block !important;
          font-size: inherit !important;
          max-height: none !important;
          line-height: inherit !important;
          overflow: visible !important;
          width: auto !important;
          visibility: visible !important;
        }

        .o_hide-xs,
        .o_hide-xs.o_col_i {
          display: none !important;
          font-size: 0 !important;
          max-height: 0 !important;
          width: 0 !important;
          line-height: 0 !important;
          overflow: hidden !important;
          visibility: hidden !important;
          height: 0 !important;
        }

        .o_xs-center {
          text-align: center !important;
        }

        .o_xs-left {
          text-align: left !important;
        }

        .o_xs-right {
          text-align: left !important;
        }

        table.o_xs-left {
          margin-left: 0 !important;
          margin-right: auto !important;
          float: none !important;
        }

        table.o_xs-right {
          margin-left: auto !important;
          margin-right: 0 !important;
          float: none !important;
        }

        table.o_xs-center {
          margin-left: auto !important;
          margin-right: auto !important;
          float: none !important;
        }

        h1.o_heading {
          font-size: 32px !important;
          line-height: 41px !important;
        }

        h2.o_heading {
          font-size: 26px !important;
          line-height: 37px !important;
        }

        h3.o_heading {
          font-size: 20px !important;
          line-height: 30px !important;
        }

        .o_xs-py-md {
          padding-top: 24px !important;
          padding-bottom: 24px !important;
        }

        .o_xs-pt-xs {
          padding-top: 8px !important;
        }

        .o_xs-pb-xs {
          padding-bottom: 8px !important;
        }
      }

      @media screen {
        @font-face {
          font-family: Roboto;
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
        }

        @font-face {
          font-family: Roboto;
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
        }

        @font-face {
          font-family: Roboto;
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
        }

        @font-face {
          font-family: Roboto;
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
        }

        .o_sans,
        .o_heading {
          font-family: "Roboto", sans-serif !important;
        }

        .o_heading,
        strong,
        b {
          font-weight: 700 !important;
        }

        a[x-apple-data-detectors] {
          color: inherit !important;
          text-decoration: none !important;
        }
      }
    </style>
    <!--[if mso]>
<style>      table { border-collapse: collapse; }      .o_col { float: left; }    </style>
<xml>
	<o:OfficeDocumentSettings>
		<o:PixelsPerInch>96</o:PixelsPerInch>
	</o:OfficeDocumentSettings>
</xml>
<![endif]-->
  </head><body class="o_body o_bg-light" style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
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
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
                    <a href="#" target="_blank">
                      <img src="##CompanyLogo##" alt="" width="160" height="160" style="border-width:0; height:auto; display:block" align="left" />
                    </a>
                  </td>
                </tr>
                <tr>
                  <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
                    <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                      <tbody>
                        <tr>
                          <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                            <img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                          </td>
                        </tr>
                        <tr>
                          <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                        </tr>
                      </tbody>
                    </table>
                    <h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">##StepName## Documents are Waiting For Approval</h2>
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
                    <p style="margin-top: 0px;margin-bottom: 0px;">We are pleased to inform that ##StepName## documents are submitted. Please verify those details. Ignore if it''s already done.</p>
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
                    <p style="margin-top: 0px;margin-bottom: 0px;">Please click the following link on your browser to verify those details</p>
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
                          <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                            <a class="o_text-white" href="##siteUrl##" style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">Click Here</a>
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
                  <td class="o_bg-white" style="font-size: 24px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp; </td>
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
    <!-- alert-primary -->
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
                  <td class="o_bg-white" style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp; </td>
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
      <tbody></tbody>
    </table>
  </body>
</html>' WHERE EmailTemplateName ='PurchaseDocumentRemind'
UPDATE EmailTemplates SET EmailTemplate ='<!doctype html>
<html lang="en">

  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="x-apple-disable-message-reformatting">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>XP1Request</title>
    <style type="text/css">
      a {
        text-decoration: none;
        outline: none;
      }

      @media (max-width: 649px) {
        .o_col-full {
          max-width: 100% !important;
        }

        .o_col-half {
          max-width: 50% !important;
        }

        .o_hide-lg {
          display: inline-block !important;
          font-size: inherit !important;
          max-height: none !important;
          line-height: inherit !important;
          overflow: visible !important;
          width: auto !important;
          visibility: visible !important;
        }

        .o_hide-xs,
        .o_hide-xs.o_col_i {
          display: none !important;
          font-size: 0 !important;
          max-height: 0 !important;
          width: 0 !important;
          line-height: 0 !important;
          overflow: hidden !important;
          visibility: hidden !important;
          height: 0 !important;
        }

        .o_xs-center {
          text-align: center !important;
        }

        .o_xs-left {
          text-align: left !important;
        }

        .o_xs-right {
          text-align: left !important;
        }

        table.o_xs-left {
          margin-left: 0 !important;
          margin-right: auto !important;
          float: none !important;
        }

        table.o_xs-right {
          margin-left: auto !important;
          margin-right: 0 !important;
          float: none !important;
        }

        table.o_xs-center {
          margin-left: auto !important;
          margin-right: auto !important;
          float: none !important;
        }

        h1.o_heading {
          font-size: 32px !important;
          line-height: 41px !important;
        }

        h2.o_heading {
          font-size: 26px !important;
          line-height: 37px !important;
        }

        h3.o_heading {
          font-size: 20px !important;
          line-height: 30px !important;
        }

        .o_xs-py-md {
          padding-top: 24px !important;
          padding-bottom: 24px !important;
        }

        .o_xs-pt-xs {
          padding-top: 8px !important;
        }

        .o_xs-pb-xs {
          padding-bottom: 8px !important;
        }
      }

      @media screen {
        @font-face {
          font-family: Roboto;
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
        }

        @font-face {
          font-family: Roboto;
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
        }

        @font-face {
          font-family: Roboto;
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
        }

        @font-face {
          font-family: Roboto;
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
        }

        .o_sans,
        .o_heading {
          font-family: "Roboto", sans-serif !important;
        }

        .o_heading,
        strong,
        b {
          font-weight: 700 !important;
        }

        a[x-apple-data-detectors] {
          color: inherit !important;
          text-decoration: none !important;
        }
      }
    </style>
    <!--[if mso]>
<style>      table { border-collapse: collapse; }      .o_col { float: left; }    </style>
<xml>
	<o:OfficeDocumentSettings>
		<o:PixelsPerInch>96</o:PixelsPerInch>
	</o:OfficeDocumentSettings>
</xml>
<![endif]-->
  </head><body class="o_body o_bg-light" style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
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
               <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
                  style="max-width: 632px;margin: 0 auto;">
                  <tbody>
                     <tr>
                        <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center"
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                           <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white"
                                 style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##"
                                    width="136" height="36"
                                    style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
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
                          <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                            <img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                          </td>
                        </tr>
                        <tr>
                          <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                        </tr>
                      </tbody>
                    </table>
                    <h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">##StepName## Documents are rejected</h2>
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
                    <p style="margin-top: 0px;margin-bottom: 0px;">We are pleased to inform that submitted ##StepName## documents are rejected. Please have a look on it. Ignore if it''s already done.</p>
                    </p>
					
					<p style="margin-top: 0px;margin-bottom: 0px;">##Comment##</p>
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
                    <p style="margin-top: 0px;margin-bottom: 0px;">Please click the following link on your browser to verify those details</p>
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
                          <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                            <a class="o_text-white" href="##siteUrl##" style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">Click Here</a>
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
                  <td class="o_bg-white" style="font-size: 24px;line-height: 8px;height: 8px;background-color: #ffffff;">&nbsp; </td>
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
    <!-- alert-primary -->
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
                  <td class="o_bg-white" style="font-size: 48px;line-height: 16px;height: 16px;background-color: #ffffff;">&nbsp; </td>
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
      <tbody></tbody>
    </table>
  </body>
</html>' WHERE EmailTemplateName ='PurchaseRejectedEmail'

END
GO