CREATE PROCEDURE [dbo].[Marker378]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @Currentdate DATETIME = GETDATE()

    MERGE INTO [dbo].[ContractStatus] AS Target 
            USING ( VALUES
                (NEWID(), 'Draft', 'Draft', '#6c757d', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Draft shared', 'Draft shared', '#B1D3F8', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Draft approved', 'Draft approved', '#76E8E0', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Draft rejected', 'Draft rejected', '#FF0038', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Signature inprogress', 'Signature inprogress', '#FAC000', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Signatures done', 'Signatures done', '#F97FBC', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Contract cancelled', 'Contract cancelled', '#FAC000', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Linked', 'Linked', '#00D1FF', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'In exceution', 'In exceution', '#4E00FF', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Closed', 'Closed', '#91C483', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Sealed/Open', 'Sealed/Open', '#00D1FF', @Currentdate, @UserId,@CompanyId)
            )
            AS Source ([Id], [StatusName], [ContractStatusName], [StatusColor], [CreatedDateTime], [CreatedByUserId],[CompanyId])
            ON Target.[StatusName] = Source.[StatusName]  AND Target.CompanyId=Source.CompanyId
            WHEN MATCHED THEN 
            UPDATE SET [StatusName] = Source.[StatusName],
                       [StatusColor] = Source.[StatusColor],
                       [CompanyId] = Source.[CompanyId],
                       [CreatedDateTime] = Source.[CreatedDateTime],
                       [CreatedByUserId] = Source.[CreatedByUserId]
            WHEN NOT MATCHED BY TARGET THEN 
            INSERT ([Id], [StatusName],[ContractStatusName], [StatusColor], [CreatedDateTime], [CreatedByUserId], [CompanyId]) 
            VALUES ([Id], [StatusName],[ContractStatusName], [StatusColor], [CreatedDateTime], [CreatedByUserId], [CompanyId]);

     DECLARE @Template TABLE
	(
		EmailTemplateName NVARCHAR(250)
		,[EmailTemplate] NVARCHAR(MAX)
		,[EmailSubject] NVARCHAR(2000)
        ,[EmailTemplateReferenceId] UNIQUEIDENTIFIER
	)

	INSERT INTO @Template(EmailTemplateName,EmailTemplate,EmailSubject,EmailTemplateReferenceId)
	VALUES
	('ShareDraftContractToSellerTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','Draft purchase contract for ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'09AB45D0-FC65-49C4-B279-877A3616FCC7')
,('ShareDraftContractToBuyerTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','Draft sale contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'B30090CD-4835-425B-9981-04640384811D')


   ,('DraftSignatureEmailToSellerTemplate','<!doctype html>
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
       
       </html>','Signature for purchase contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'5B9D6391-E20A-4089-9E9B-C1B6D3258B65')

   ,('DraftSignatureEmailToBuyerTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','Signature for sale contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'BD53C58E-A3B9-4C59-8EF9-40F23D3D3E16')

   ,('DraftPurchaseContractApproveEmailToSGTraderTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','Draft acceptance for purchase contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'C3109B8D-96A7-44E6-A08C-260FF8D046DE')
   ,('DraftPurchaseContractRejectEmailToSGTraderTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','Draft rejection for purchase contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'3F1E2D41-CE4F-4F88-B7C4-B2E9CA6B5A0B')
   ,('DraftSaleContractApproveEmailToSGTraderTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','Draft acceptance for sale contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'6D802579-1F66-409A-9292-78736F25D361')
   ,('DraftSaleContractRejectEmailToSGTraderTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','Draft rejection for sale contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'6BC7E54E-95ED-4600-92E7-21827AE275B4')
   ,('SellerSignatureAcceptEmailTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','Seller signature acceptance for purchase contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'469B5878-08E8-48E2-92A0-C17F01D564C9')
   ,('BuyerSignatureAcceptEmailTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','Buyer signature acceptance for sales contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'CA5BFB94-5928-4654-A1BE-83525882C5CF')
   ,('SellerSignatureRejectEmailTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','Seller signature rejection for purchase contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'BD131A6C-1E20-44B1-A433-A6B6AB6EAB10')
   ,('BuyerSignatureRejectEmailTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','Buyer signature rejection for sales contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'BAF6AE59-A3FE-4761-B347-4DD817C8F0BD')
   ,('SGTraderSignatureAcceptEmailBySellerTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','SG Trade signature acceptance for purchase contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'0501986E-82D3-4E88-9DC9-5ADA6A8752C0')
   ,('SGTraderSignatureAcceptEmailByBuyerTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','SG Trade signature acceptance for sales contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'7B2807A6-07A5-43F0-9818-CFC23BB5F068')
   ,('SGTraderSignatureRejectEmailBySellerTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','SG Trade signature rejection for purchase contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'44123A65-DBCF-4D18-A29A-55AFD84A1341')
   ,('SGTraderSignatureRejectEmailByBuyerTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','SG Trade signature rejection for sales contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'36AF9898-231B-4AF5-A8E9-C57856B4C0A2')
   ,('PurchaseContractSealingEmailTemplate','<!doctype html>
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
                              Purchase contract sealed for ##ContractId##
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
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the contract is sealed and ready for your next action
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','purchase contract for ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit## is sealed',N'076CAD66-4827-4E18-B1A7-0E4F5EA1D78F')
   ,('SellerContractSealingEmailTemplate','<!doctype html>
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
                              Sales contract sealed for ##ContractId##
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
                           <p style="margin-top: 0px;margin-bottom: 0px;">Hello, <br>Please find the contract is sealed and ready for your next action
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','Seller contract for ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit## is sealed',N'FC8F06EB-C92E-4631-93B6-EB169A7FABB4')
,('SGTraderSignatureEmailForPurchaseContractTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','Signature for purchase contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'C46B5FD7-A2A4-4D78-BBFA-70B3D7FDD18A')
,('SGTraderSignatureEmailForSellerContractTemplate','<!doctype html>
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
                           style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp;
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
   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation"
      style="max-width: 632px;margin: 0 auto;">
      <tbody>
         <tr>
            <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center"
               style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
               <div class="o_col o_col-4"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights
                        reserved</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944 -
                        info@snovasys.com</p>
                     <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road
                        London - TW4 6JQ</p>
                     <p style="margin-top: 0px;margin-bottom: 0px;"> Learn more at <a
                           class="o_text-dark_light o_underline" href=##Registersite##
                           style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> </p>
                  </div>
               </div>
               <!--[if mso]>
                   </td>
                   <td width="400" align="right" valign="top" style="padding:0px 8px;">
                      <![endif]-->
               <div class="o_col o_col-2"
                  style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center"
                     style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                     <p style="margin-top:0;margin-bottom:0"> <a class="o_text-dark_light"
                           href="https://www.facebook.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/facebookicon.png"
                              width="36" height="36" alt="fb"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://twitter.com/snovasys"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/twittericon.png"
                              width="36" height="36" alt="tw"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                        <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/"
                           style="text-decoration:none;outline:0;color:#a0a3ab"><img
                              src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/linkedIn.png" width="36"
                              height="36" alt="ig"
                              style="max-width:36px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none"></a><span>&nbsp;</span>
                     </p>
                  </div>
               </div>
            </td>
         </tr>
      </tbody>
   </table>
</body>

</html>','Signature for sale contract ##ContractId## for ##Commodity## - ##Quantity## ##MeasurementUnit##',N'39CBA32C-293D-4F4D-BEB6-90704C17E98B')

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
            --Draft Purchase
	        (NEWID(), N'##Quantity##', N'09AB45D0-FC65-49C4-B279-877A3616FCC7','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'09AB45D0-FC65-49C4-B279-877A3616FCC7','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'09AB45D0-FC65-49C4-B279-877A3616FCC7','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'09AB45D0-FC65-49C4-B279-877A3616FCC7','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'09AB45D0-FC65-49C4-B279-877A3616FCC7','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'09AB45D0-FC65-49C4-B279-877A3616FCC7','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
	        
            --Draft Sale
           ,(NEWID(), N'##Quantity##', N'B30090CD-4835-425B-9981-04640384811D','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'B30090CD-4835-425B-9981-04640384811D','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'B30090CD-4835-425B-9981-04640384811D','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'B30090CD-4835-425B-9981-04640384811D','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'B30090CD-4835-425B-9981-04640384811D','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'B30090CD-4835-425B-9981-04640384811D','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
            
            --Purchase Seller Signature
           ,(NEWID(), N'##Quantity##', N'5B9D6391-E20A-4089-9E9B-C1B6D3258B65','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'5B9D6391-E20A-4089-9E9B-C1B6D3258B65','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'5B9D6391-E20A-4089-9E9B-C1B6D3258B65','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'5B9D6391-E20A-4089-9E9B-C1B6D3258B65','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'5B9D6391-E20A-4089-9E9B-C1B6D3258B65','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'5B9D6391-E20A-4089-9E9B-C1B6D3258B65','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
            --Sale Buyer Signature
           ,(NEWID(), N'##Quantity##', N'BD53C58E-A3B9-4C59-8EF9-40F23D3D3E16','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'BD53C58E-A3B9-4C59-8EF9-40F23D3D3E16','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'BD53C58E-A3B9-4C59-8EF9-40F23D3D3E16','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'BD53C58E-A3B9-4C59-8EF9-40F23D3D3E16','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'BD53C58E-A3B9-4C59-8EF9-40F23D3D3E16','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'BD53C58E-A3B9-4C59-8EF9-40F23D3D3E16','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
            --Purchase SGTrader Signature
           ,(NEWID(), N'##Quantity##', N'C46B5FD7-A2A4-4D78-BBFA-70B3D7FDD18A','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'C46B5FD7-A2A4-4D78-BBFA-70B3D7FDD18A','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'C46B5FD7-A2A4-4D78-BBFA-70B3D7FDD18A','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'C46B5FD7-A2A4-4D78-BBFA-70B3D7FDD18A','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'C46B5FD7-A2A4-4D78-BBFA-70B3D7FDD18A','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'C46B5FD7-A2A4-4D78-BBFA-70B3D7FDD18A','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
            --Sale SGtrader Signature
           ,(NEWID(), N'##Quantity##', N'39CBA32C-293D-4F4D-BEB6-90704C17E98B','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'39CBA32C-293D-4F4D-BEB6-90704C17E98B','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'39CBA32C-293D-4F4D-BEB6-90704C17E98B','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'39CBA32C-293D-4F4D-BEB6-90704C17E98B','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'39CBA32C-293D-4F4D-BEB6-90704C17E98B','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'39CBA32C-293D-4F4D-BEB6-90704C17E98B','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           
           --Purchase Draft Approve
           ,(NEWID(), N'##Quantity##', N'C3109B8D-96A7-44E6-A08C-260FF8D046DE','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'C3109B8D-96A7-44E6-A08C-260FF8D046DE','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'C3109B8D-96A7-44E6-A08C-260FF8D046DE','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'C3109B8D-96A7-44E6-A08C-260FF8D046DE','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'C3109B8D-96A7-44E6-A08C-260FF8D046DE','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'C3109B8D-96A7-44E6-A08C-260FF8D046DE','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           --Purchase Draft Reject
           ,(NEWID(), N'##Quantity##', N'3F1E2D41-CE4F-4F88-B7C4-B2E9CA6B5A0B','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'3F1E2D41-CE4F-4F88-B7C4-B2E9CA6B5A0B','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'3F1E2D41-CE4F-4F88-B7C4-B2E9CA6B5A0B','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'3F1E2D41-CE4F-4F88-B7C4-B2E9CA6B5A0B','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'3F1E2D41-CE4F-4F88-B7C4-B2E9CA6B5A0B','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'3F1E2D41-CE4F-4F88-B7C4-B2E9CA6B5A0B','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
            --Sale Draft Approve
           ,(NEWID(), N'##Quantity##', N'6D802579-1F66-409A-9292-78736F25D361','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'6D802579-1F66-409A-9292-78736F25D361','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'6D802579-1F66-409A-9292-78736F25D361','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'6D802579-1F66-409A-9292-78736F25D361','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'6D802579-1F66-409A-9292-78736F25D361','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'6D802579-1F66-409A-9292-78736F25D361','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           --Sale Draft Reject
           ,(NEWID(), N'##Quantity##', N'6BC7E54E-95ED-4600-92E7-21827AE275B4','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'6BC7E54E-95ED-4600-92E7-21827AE275B4','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'6BC7E54E-95ED-4600-92E7-21827AE275B4','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'6BC7E54E-95ED-4600-92E7-21827AE275B4','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'6BC7E54E-95ED-4600-92E7-21827AE275B4','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'6BC7E54E-95ED-4600-92E7-21827AE275B4','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           --Seller signature accept
           ,(NEWID(), N'##Quantity##', N'469B5878-08E8-48E2-92A0-C17F01D564C9','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'469B5878-08E8-48E2-92A0-C17F01D564C9','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'469B5878-08E8-48E2-92A0-C17F01D564C9','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'469B5878-08E8-48E2-92A0-C17F01D564C9','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'469B5878-08E8-48E2-92A0-C17F01D564C9','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'469B5878-08E8-48E2-92A0-C17F01D564C9','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           --Buyer sales signature accept
           ,(NEWID(), N'##Quantity##', N'CA5BFB94-5928-4654-A1BE-83525882C5CF','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'CA5BFB94-5928-4654-A1BE-83525882C5CF','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'CA5BFB94-5928-4654-A1BE-83525882C5CF','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'CA5BFB94-5928-4654-A1BE-83525882C5CF','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'CA5BFB94-5928-4654-A1BE-83525882C5CF','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'CA5BFB94-5928-4654-A1BE-83525882C5CF','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           --Seller signature accept
           ,(NEWID(), N'##Quantity##', N'BD131A6C-1E20-44B1-A433-A6B6AB6EAB10','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'BD131A6C-1E20-44B1-A433-A6B6AB6EAB10','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'BD131A6C-1E20-44B1-A433-A6B6AB6EAB10','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'BD131A6C-1E20-44B1-A433-A6B6AB6EAB10','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'BD131A6C-1E20-44B1-A433-A6B6AB6EAB10','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'BD131A6C-1E20-44B1-A433-A6B6AB6EAB10','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           --Buyer sales signature accept
           ,(NEWID(), N'##Quantity##', N'BAF6AE59-A3FE-4761-B347-4DD817C8F0BD','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'BAF6AE59-A3FE-4761-B347-4DD817C8F0BD','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'BAF6AE59-A3FE-4761-B347-4DD817C8F0BD','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'BAF6AE59-A3FE-4761-B347-4DD817C8F0BD','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'BAF6AE59-A3FE-4761-B347-4DD817C8F0BD','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'BAF6AE59-A3FE-4761-B347-4DD817C8F0BD','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           --SG Trader purchase signature accept
           ,(NEWID(), N'##Quantity##', N'0501986E-82D3-4E88-9DC9-5ADA6A8752C0','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'0501986E-82D3-4E88-9DC9-5ADA6A8752C0','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'0501986E-82D3-4E88-9DC9-5ADA6A8752C0','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'0501986E-82D3-4E88-9DC9-5ADA6A8752C0','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'0501986E-82D3-4E88-9DC9-5ADA6A8752C0','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'0501986E-82D3-4E88-9DC9-5ADA6A8752C0','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           --SG Trader sale signature accept
           ,(NEWID(), N'##Quantity##', N'7B2807A6-07A5-43F0-9818-CFC23BB5F068','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'7B2807A6-07A5-43F0-9818-CFC23BB5F068','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'7B2807A6-07A5-43F0-9818-CFC23BB5F068','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'7B2807A6-07A5-43F0-9818-CFC23BB5F068','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'7B2807A6-07A5-43F0-9818-CFC23BB5F068','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'7B2807A6-07A5-43F0-9818-CFC23BB5F068','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           --SG Trader seller sale signature reject
           ,(NEWID(), N'##Quantity##', N'44123A65-DBCF-4D18-A29A-55AFD84A1341','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'44123A65-DBCF-4D18-A29A-55AFD84A1341','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'44123A65-DBCF-4D18-A29A-55AFD84A1341','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'44123A65-DBCF-4D18-A29A-55AFD84A1341','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'44123A65-DBCF-4D18-A29A-55AFD84A1341','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'44123A65-DBCF-4D18-A29A-55AFD84A1341','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
            --SG Trader buyer purchase signature reject
           ,(NEWID(), N'##Quantity##', N'36AF9898-231B-4AF5-A8E9-C57856B4C0A2','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'36AF9898-231B-4AF5-A8E9-C57856B4C0A2','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'36AF9898-231B-4AF5-A8E9-C57856B4C0A2','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'36AF9898-231B-4AF5-A8E9-C57856B4C0A2','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'36AF9898-231B-4AF5-A8E9-C57856B4C0A2','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'36AF9898-231B-4AF5-A8E9-C57856B4C0A2','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           --Purchase seal
           ,(NEWID(), N'##Quantity##', N'076CAD66-4827-4E18-B1A7-0E4F5EA1D78F','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'076CAD66-4827-4E18-B1A7-0E4F5EA1D78F','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'076CAD66-4827-4E18-B1A7-0E4F5EA1D78F','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'076CAD66-4827-4E18-B1A7-0E4F5EA1D78F','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'076CAD66-4827-4E18-B1A7-0E4F5EA1D78F','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'076CAD66-4827-4E18-B1A7-0E4F5EA1D78F','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           --Sale seal
           ,(NEWID(), N'##Quantity##', N'FC8F06EB-C92E-4631-93B6-EB169A7FABB4','This is contract name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ContractId##', N'FC8F06EB-C92E-4631-93B6-EB169A7FABB4','This is the url to login to the system for contract view', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'FC8F06EB-C92E-4631-93B6-EB169A7FABB4','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PriceAmount##',N'FC8F06EB-C92E-4631-93B6-EB169A7FABB4','This is the register site address used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'FC8F06EB-C92E-4631-93B6-EB169A7FABB4','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'FC8F06EB-C92E-4631-93B6-EB169A7FABB4','This is the contract quantity', @CompanyId, GETDATE(), @UserId, NULL)

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
END
GO