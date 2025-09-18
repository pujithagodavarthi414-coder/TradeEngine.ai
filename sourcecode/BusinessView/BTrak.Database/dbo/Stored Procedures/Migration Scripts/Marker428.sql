CREATE PROCEDURE [dbo].[Marker428]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
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
                              SwitchBl accept/reject for ##ContractId##
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
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Quantity## ##MeasurementUnit##
                                    </td>
                                 </tr>
								 <tr>
									<td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       CounterParty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##CounterPartyName##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please accept/reject the switchbl for your next action.<br>
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

</html>' WHERE EmailTemplateName = 'SwitchBlContractAcceptOrRejectMailToBuyerTemplate'

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
                              SwitchBL is accepted by ##BuyerName## for ##ContractId##
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
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Quantity## ##MeasurementUnit##
                                    </td>
                                 </tr>
								 <tr>
									<td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       CounterParty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##CounterPartyName##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the buyer accepted swichbl for your next action.<br>
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

</html>' WHERE EmailTemplateName = 'SwitchBlBuyerAcceptenceMailToSgTraderTemplate'
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
                              SwitchBL is rejected by ##BuyerName## for ##ContractId##
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
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Quantity## ##MeasurementUnit##
                                    </td>
                                 </tr>
								 <tr>
									<td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       CounterParty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##CounterPartyName##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the buyer rejected swichbl for your next action.<br>
						   Comments : ##Comment## <br/>
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

</html>' WHERE EmailTemplateName = 'SwitchBlBuyerRejectionMailToSgTraderTemplate'
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
                              SwitchBl vessel owner accept/reject for ##ContractId##
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
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       Qty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;">
                                       ##Quantity## ##MeasurementUnit##
                                    </td>
                                 </tr>
								 <tr>
									<td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       CounterParty:
                                    </td>
                                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center"
                                       style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-bottom: 16px;">
                                       ##CounterPartyName##
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please accept/reject the switchbl for your next action.<br>
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

</html>' WHERE EmailTemplateName = 'SwitchBlContractMailToVesselOwnerTemplate'
UPDATE EmailTemplates  SET EmailSubject = 'SwitchBL contract is accepted by ##BuyerName##' WHERE EmailTemplateName = 'SwitchBlBuyerAcceptenceMailToSgTraderTemplate'
UPDATE EmailTemplates  SET EmailSubject = 'SwitchBL contract is rejected by ##BuyerName##' WHERE EmailTemplateName = 'SwitchBlBuyerRejectionMailToSgTraderTemplate'
UPDATE EmailTemplates SET EmailTemplate = '<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>INVOICE</title>
    <style>
        #pageborder {
            position: fixed;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            border: 2px solid black;
        }

        @page {
            margin: 1.5cm;

            @top-center {
                content: element(pageHeader);
            }

            @bottom-center {
                content: element(pageFooter);
            }
        }

        #pageHeader {
            position: running(pageHeader);
        }

        #pageFooter {
            position: running(pageFooter);
        }

        @media print {
            .terms-page-break {
                page-break-before: always;
            }
        }

        body {
            background-color: #F6F6F6;
            margin: 0;
            padding: 0;
        }

        h1,
        h2,
        h3,
        h4,
        h5,
        h6 {
            margin: 0;
            padding: 0;
        }

        p {
            margin: 0;
            padding: 0;
        }

        .container {
            width: 95%;
            margin-right: auto;
            margin-left: auto;
        }

        .brand-section {
            background-color: #0d1033;
            padding: 10px 40px;
        }

        .row {
            display: flex;
            flex-wrap: wrap;
        }

        .col-6 {
            width: 50%;
            flex: 0 0 auto;
        }

        .text-white {
            color: #fff;
        }

        .company-details {
            float: right;
            text-align: right;
        }



        .heading {
            font-size: 20px;
            margin-bottom: 08px;
        }

        .sub-heading {
            color: #262626;
            margin-bottom: 05px;
        }

        .w-20 {
            width: 20%;
        }

        .float-right {
            float: right;
        }

        span {
            text-decoration: underline;
            color: blue;
        }
    </style>
</head>

<body>
    <div class="container">
        <div id="pageborder">
        </div>
        <div class="body-section">
            <div class="row">
                <div class="col-6">
                    <p style="margin-top:10px">Shipped in apparent good order and condition by</p>
                    <hr style="background: blue;">
                    <p class="sub-heading">Shipper</p>
                </div>
                <div class="col-6">
                    <p class="sub-heading"
                        style="margin-left: 50px; font-size: 26px; font-weight: bolder;margin-top:10px">Tanker Bill
                        of Landing</p>
                    <p class="sub-heading" style="margin-left: 50px; font-weight: bolder;">B/L NO. CY/DMI/HAL-02</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">##Shipper##</p>
                    <hr style="background: blue;">
                    <p class="sub-heading">Consignee/Order of</p>
                </div>
            </div>
            <div class="row">
                <div class="col-6">
                    <p class="sub-heading">TO ORDER</p> <br>
                    <hr style="background: blue;">
                    <p class="sub-heading">Notify Address</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">##NotifyAddress##</p>
                </div>
            </div>
            <div class="col-12">
                <hr style="background: blue;">
            </div>
            <div class="row">
                <div class="col-4">
                    <p class="sub-heading">On Board the tanker</p>
                    <p class="sub-heading">##OnBoardTanker##</p>
                </div>
                <div class="col-4" style="margin-left: 50px;">
                    <p class="sub-heading">Flag</p>
                    <p class="sub-heading">##Flag##</p>
                </div>
                <div class="col-4" style="margin-left: 50px;">
                    <p class="sub-heading">Master</p>
                    <p class="sub-heading">##Master##</p>
                </div>
            </div>
            <div class="col-12">
                <hr style="background: blue;">
            </div>
            <div class="row">
                <div class="col-4">
                    <p class="sub-heading">Loaded at the port of</p>
                    <p class="sub-heading">##LoadedAtPort##</p>
                </div>
                <div class="col-4" style="margin-left: 50px;">
                    <p class="sub-heading">To be delivered to the port of</p>
                    <p class="sub-heading">##DeliveredPort##</p>
                </div>
                <div class="col-4" style="margin-left: 50px;">
                    <p class="sub-heading">Voyage Number</p>
                    <p class="sub-heading">##VoyageNumber##</p>
                </div>
            </div>
            <div class="col-12">
                <hr style="background: blue;">
                <p class="sub-heading" style="margin-bottom: 10px;">A Quantity in bulk said by the Shipper to be:</p>
            </div>
            <div class="row">
                <div class="col-6">
                    <p class="sub-heading">COMMODITY (Name of product)</p>
                    <p class="sub-heading">##Commodity##</p>
                </div>
                <div class="col-6">
                    <p class="sub-heading" style="margin-left: 50px;">QUANTITY (lbs, tonnes, barrels, gallons</p>
                    <p class="sub-heading" style="margin-left: 50px;">##Quantity##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 20px;">
                    <p class="sub-heading">OCEAN CARRIAGE STOWAGE: ##OceanCarriageStowage##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 20px;">
                    <p class="sub-heading">This shipment of <span> ##Quantity## </span> Metrie tons was loaded on board
                        the Vessel as part of one original lot of <span> ##Quantity## </span> Metrie tons stowed in
                        <span> ##SLOPS## </span> with no segregation as to parcels. For the whole shipment <span>
                            ##TotalBlNumbers## </span> set Of Bill of Lading have been issued for which the Vessel is
                        relieved from all responsibilities to the extent it would be if one sel only would have been
                        issued. The Vessel undertakes to deliver only that portion of the cargo actually loaded which is
                        represented by the percentage that the total amount specifed in the Bill(s) of Lading bears to
                        the foal of the commingling shipment delivered at destination. Neither the Vessel nor the overs
                        assume any responsibility for the consequences of such commingling nor for the separation
                        thereof at the time of delivery.
                    </p>
                    <p class="sub-heading" style="margin-top: 10px;">The quantity, measurement, weight, gauge, quality,
                        nature and value and actual condilion of the cargo unknorm to the Vessel and the Maser, lo be
                        delivered to the port of discharge or so near there to as the Vessel can safely get, always a
                        float upon prior payment of freight as agreed. Cargo is warranted free of danger to Vessel
                        except for the usual risks inherent in the carriage of the commodity as described.</p>
                    <p class="sub-heading" style="margin-top: 10px;">This shipment is carried under and pursuant to the
                        forms of the Charter daled <span> ##CharteredDate## </span> Between <span> AS PER CHARTER
                            PARTY </span> As Owners and <span> AS PER CHARTER PARTY </span> As Charterers, and all
                        conditions. Liberties And exception whatsoever of the said Charier apply to and govern the
                        rights of the parties concerned in this shipment. The Clause Paramount, New Jason Clause and
                        Both to Blame Collision Clause as set out on the reverse of this Bill of Lading are hereby
                        incorpornled herein and shall remain in effect even if unenforceable in the United States of
                        America, General Average payment according to the York-Antwerp Rules 1974, as amended 1994.</p>
                    <p class="sub-heading">The Master is authorized to act for all interests in arranging for salvage
                        assistance on lerms of Lloyds Open Form. The freight is payable discountless and is earned
                        concurrent with loading, ship and/or cargo lost or not lost or abandoned. </p>
                    <p class="sub-heading">The Overs shall have an absolute lien on he cargo for all freight.
                        Deadfreight, demurrage, damages for detention and all other monies due under the above mentioned
                        Charter or under this Bill of Lading, logether with the costs and expenses, including attorneys
                        fees, of recovering same, and shall be antitled to sell or otherwise dispose of the property
                        lined and apply the proceeds towards satisfaction of such liability.</p>
                    <p class="sub-heading" style="margin-top: 10px;">The contract of carriage evidenced by this Bill of
                        Lading is between the shipper, consignee and/or over of the cargo and the owner or demise
                        charterers of the Vessel named herein to carry the cargo described above,</p>
                    <p class="sub-heading">carrior or baile of said shipment or under any responsibility with respect
                        thereto, all limitations af or exonerations from liability and all defences provided by law or
                        by the terms of the contract of carriage shall be available to such other</p>
                    <p class="sub-heading" style="margin-top: 10px;">All of he provisions written, printed or stamped on
                        either side hereof are part of this Bill of Lading Contract. In Witness Whereof, the master has
                        signed <span> #3 (THREE) ORIGINALS# </span> Bills of Lading of this tenor and date, one of which
                        being accomplished, the others will be void.</p>
                    <p class="sub-heading">Dated at <span> ##IssuedPlace## </span> this <span> ##SignedDay## </span> day
                        of
                        <span> ##SignedMonth## </span> <span> ##SignedYear## </span>
                    </p>
                </div>
            </div>
            <div class="row">
                <div class="col-6" style="margin-top: 50px;"></div>
                <div class="col-6" style="margin-top: 50px;">
                    <hr style="background: #000;">
                    <p class="sub-heading" style="text-align: center;">As Agents for and on behalf the master</p>
                    <p class="sub-heading" style="text-align: center;">CAPT. SEO PAN GI</p>
                </div>
            </div>
            <div class="row terms-page-break">
                <div class="col-12" style="margin-top: 20px;">
                    <p class="sub-heading" style="font-weight: bolder;">BILL OF LANDING</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 5px;">
                    <p class="sub-heading">TO BE USED WITH CHARTER-PARTIES</p>
                </div>
            </div>
            <div class="row">
                <div style="width:38%"></div>
                <div class="col-6">
                    <p class="sub-heading">Conditions of Carriage</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(1) Ceneral Paramount Clause</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(a) The Hague Rules contained
                        in the International Convention for the Unification of certain rules relating to Bills of
                        Landing, dated Brussels the 25% August 1924 as enncted in the country of shipment, shall apply
                        to this Bill of Landing When no such enactment is in force the country of shipment. the
                        corresponding legislation of the country of destination shall apply, but in respect of shipments
                        to which no such enactments are compulsorily applicable, the terms of the said Convention shall
                        apply.</p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(b) Trades where Hauge-Visby
                        Rules apply. In trades where the International Brussels Convention 1924 as amended by the
                        Protocol signed at Brussels on February 23 196&- the Hague-Visby Rules-apply compulsorily, the
                        provisions of the respective legislation shall apply to this Bill of Landing</p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(c) The Carrier shall in no
                        case be responsible for the loss of or damage to the cargo, howsoever arising prior to loading
                        into and affer discharge from the Vessel or while the cargo is in the charge of another Carrier,
                        nor in respect of deck cargo or live animals.</p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(d) If the carriage covered
                        by this Bill of Landing includes Carriage to or from a port or place in the United States of
                        America, this Bill of Landing shall be subject to the United States Carriage of Goods by Sea Act
                        1939 (US COGS A), the terms of which are incorporated herein and shall govern throughout the
                        entire Carriage set forth in this Bill of Landing Neither the Hague or Hague-Visby Rules shall
                        apply to the Carriage to or from the United States. The Carrier shall be entitled to the
                        benefits of the defenses and limitations in US COGSA. whether the loss or damage to the Goods
                        occurs at sea or not.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(2) General Average</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">General Average shall be
                        adjusted, stated and settled according to York-Antwerp Rules 1994, or any subsequent
                        modification thereof, in London unless another place is agreed in the Charter Party. Cargos
                        contribution to General Avcrage shall be paid to the Carrier even when such average is the
                        result of a fault, neglect or error of the Master, Pilot or Crew. The Charterers, Shippers,
                        Consignees and the Holder of this Bill of Landing expressly renounce the Belgian Commercial
                        Code, Part II. Art. 148,</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(3) New Jason Clause</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">In the event of accident,
                        danger, or disaster before or after the commencement of the voyage, resulting from any cause
                        whatsoever, whether due to negligence or not, for which or for the consequence of which, the
                        Carrier is not responsible, by statute, contract or otherwise, the cargo, Shippers, Cosignees,
                        the Owners of the cargo or the Holder of this Bill of Landing shall contribute with the Carrier
                        in General Average to the payment of any sacrifices, losses or expenses of a General Average
                        nature that may be made or incurred and shall pay salvage and special charges incurred in
                        respect of the cargo. If a salving vessel, is owned or operated by the Carrier, salvage shall be
                        paid for as fully as if the said salving vessel or vessels belonged to strangers. Such deposit
                        as the Carrier, or his agents, may deem suflicient to cover the estimated contribution of the
                        goods and any salvage and special charges thereon shall, if required, be made by the cargo,
                        Shippers, Consignces or Owners of the goods or Holder of this Bill of Landing to the Carrier
                        before delivery.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(4) Both-to-Blame Collision Clause</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">If the Vessel comes into
                        collision with another vessel as a result of the negligence of the other vessel and any act,
                        neglect or default of the Master, Mariner. Pilot or the servants of the Carrier in the
                        navigation or in the management of the Vessel, the owners of the cargo carried hereunder and the
                        Holder of this Bill of Landing will indemnify the Carrier against all loss of liability to the
                        other or non-carrying vessel or her owners in so far as such loss or liability represents loss
                        of, or damage to, or any claim whatsoever of the owners of said cargo, paid or payable by the
                        vessel or her owners as part of their claim against the carrying Vessel or the Carrier. The
                        foregoing provisions shall also apply where the owners, operators or those in charge of any
                        vessel or vessels or objects other than, or in addition to, the colliding vessels or objects are
                        at fault in respect of a collision or contact.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(5) Notice of Loss or Damage to the Goods</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">Unless Notice of Loss or
                        Damage to the Goods and the general nature of such loss or damage be given in writing to the
                        Carrier or his agent at the port of discharge before or at the time of the removal of the goods
                        into the custody of the person entitled to delivery thereof under the contract of carriage, or,
                        if the loss or damage be not apparent within 3 (three) days, such removal shall be prima facie
                        evidence of the delivary by the carrier of the goods as described in the bill or landing
                        (Hague-Visby Rules Article Ill Rule 6)</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(6) Time Bar</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">All liability whatsoever of
                        the Carrier shall cease unless suit is brought within 1 (one) year after delivery of the goods
                        or the date when the goods should have been delivered,</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(7) Cargo loss</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">The Carrier shall not be
                        liabla for any short outturn cargo quantity below 0.5% as determined by the discrepancy between
                        the quantity of cargo received onboard the vessel in Port of Loading and the ships ligure in
                        Port of Discharge</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(8) Limitation of Liability</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">The Carrier shall have the
                        benefit of all applicable imitations of an exemptions from liability accorded to the Carrier by
                        any laws, statues, or regulations of any country for the time being in force notwithstanding any
                        provision of the charterparty</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(9) Himalaya Cargo Clause</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">It is hereby expressly agreed
                        that no servant or agent of the Carrier (including every independent contractor from time to
                        time employed by the Carrier) shall in any circumstances whatsoever be under any liability to
                        the shipper. Consignce or owner of the cargo or to any Holder of this Bill of Landing for any
                        loss, damage or delay of whatsoever kind arising or resulting directly or indirectly from any
                        act, neglect or default on his part while acting in the course of or in connection with his
                        employment and, but without prejudice to generality of the foregoing provisions in this Clause,
                        every exemption, limitation, condition and liberty herein contained and every right, exemption
                        from liability, defense and immunity of whatsoever nature applicable to the Carrier or to which
                        the Carrier is entitled hereunder shall also be available and shall extend to protect every such
                        servant pr agent of the Carrior acting as aforesaid and for the purpose of all the foregoing
                        provisions of the Clause the Carrier is or shall be deemed to be acting as agent or trustee on
                        behalf of and for the benefit of all persons who are or might be his servants or agent from time
                        to time (including independent contractions as aforesaid) and all such-persons shall to this
                        extent be or be deemed to be parties to the contract in or evidenced by this Bill of Landing The
                        Carrier shall be entitled to be paid by the Shipper. Consignee, owner of the cargo and or Holder
                        of the Bill of Landing (who shall be jointly and severally liable to the carrier therefore) on
                        demand any sum recovered or recoverable by either such Shipper, Consignes, owner of the cargo
                        and or Holder of the Bill of Landing or any other from such servant or agent of the Carrier for
                        any such loss, damage, delay or otherwise.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 10px;">
                    <p class="sub-heading">All terms and conditions, liberties and exceptions of the BIMCO War Risk
                        Clause for Time Charters,</p>
                    <p class="sub-heading">2004 (Codename: Conwartime 2004) and amendments thereto are herewith
                        incorporated.</p>
                </div>
            </div>
        </div>
    </div>
</body>

</html>' WHERE EmailTemplateName = 'SwitchBlPdfGenerationTemplate'
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

            .logo-image {
                display: block;
                max-width: 180px;
                max-height: 180px;
                width: auto;
                height: auto;
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
                                <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light"
                                    align="center"
                                    style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
                                    <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                                        <tbody>
                                            <tr>
                                                <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max"
                                                    align="center"
                                                    style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                                                    <img src="##CompanyRegistrationLogo##" width="180" height="75" class="logo-image"
                                                        alt=""
                                                        style="-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;outline: none;text-decoration: none;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp;
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <h2 class="o_heading o_text-dark o_mb-xxs"
                                        style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">
                                        You''ve Been Invited</h2>
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
                                    style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 0px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 0px;padding-bottom: 16px;">

                                    <p style="margin-top: 0px;margin-bottom: 0px;">We are pleased to have you joining
                                        ##CompanyName##.</p>
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
                                    style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 0px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 0px;padding-bottom: 16px;">
                                    <p style="margin-top: 0px;margin-bottom: 0px;">Please click the following link to
                                        continue.</p>
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
                                    <table align="center" cellspacing="0" cellpadding="0" border="0"
                                        role="presentation">
                                        <tbody>
                                            <tr>
                                                <td width="300" class="o_btn o_bg-success o_br o_heading o_text"
                                                    align="center"
                                                    style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
                                                    <a class="o_text-white" href="##siteUrl##"
                                                        style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">Join
                                                        Us</a>
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
                                <td class="o_bg-white o_px-md o_py o_sans o_text-xs o_text-light" align="center"
                                    style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                                    <p class="o_mb" style="margin-top: 0px;margin-bottom: 16px;">
                                        <strong>Username</strong>
                                    </p>
                                    <table role="presentation" cellspacing="0" cellpadding="0" border="0">
                                        <tbody>
                                            <tr>
                                                <td width="284"
                                                    class="o_bg-ultra_light o_br o_text-xs o_sans o_px-xs o_py"
                                                    align="center"
                                                    style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ebf5fa;border-radius: 4px;padding-left: 8px;padding-right: 8px;padding-top: 16px;padding-bottom: 16px;">
                                                    <p class="o_text-dark"
                                                        style="color: #242b3d;margin-top: 0px;margin-bottom: 0px;">
                                                        <strong>##UserName##</strong>
                                                    </p>
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
                                <td class="o_bg-white o_px-md o_py o_sans o_text-xs o_text-light" align="center"
                                    style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                                    <p class="o_mb" style="margin-top: 0px;margin-bottom: 16px;">
                                        <strong>Password</strong>
                                    </p>
                                    <table role="presentation" cellspacing="0" cellpadding="0" border="0">
                                        <tbody>
                                            <tr>
                                                <td width="284"
                                                    class="o_bg-ultra_light o_br o_text-xs o_sans o_px-xs o_py"
                                                    align="center"
                                                    style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ebf5fa;border-radius: 4px;padding-left: 8px;padding-right: 8px;padding-top: 16px;padding-bottom: 16px;">
                                                    <p class="o_text-dark"
                                                        style="color: #242b3d;margin-top: 0px;margin-bottom: 0px;">
                                                        <strong>##Password##</strong>
                                                    </p>
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
                                    style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">
                                    &nbsp; </td>
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

</html>' WHERE EmailTemplateName = 'ClientRegistrationMail'
            UPDATE EmailTemplates SET EmailSubject = 'Stakeholder registration notification' WHERE EmailTemplateName = 'ClientRegistrationMail'
END