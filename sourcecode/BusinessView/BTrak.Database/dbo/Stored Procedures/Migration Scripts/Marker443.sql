CREATE PROCEDURE [dbo].[Marker443]
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
	VALUES('DashboardWidgetPdfTemplate','<!DOCTYPE html>
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
            <p style="margin-top:10px;">##WidgetHtmlData##</p>
    </div>
</body>

</html>','Dashboard widget pdf gemerated,view pdf for further details',N'5AD80169-088D-4786-9B42-6C7AC5191A2A'),
('DashboardWidgetTemplate','<!doctype html>
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
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
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
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 24px;padding-bottom: 5px;">
                           <h2 class="o_heading o_text-dark o_mb-xxs"
                              style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 3px;">
                              Dashboard widget information
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
                           <p style="margin-top: 5px;margin-bottom: 0px;">please find the pdf attached below<br>
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
                           style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 5px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 5px;padding-bottom: 16px;">
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
                                          dashboard</a> </td>
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

</html>','Dashboard widget information',N'5B568D43-896F-4AF6-9089-2C69B83AA977')
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
	       --Dashboard widget pdf Template
           (NEWID(), N'##WidgetHtmlData##', N'5AD80169-088D-4786-9B42-6C7AC5191A2A','Widget html code', @CompanyId, GETDATE(), @UserId, NULL)
           --Widget information template
           ,(NEWID(), N'##siteUrl##', N'5B568D43-896F-4AF6-9089-2C69B83AA977','site address', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##CompanyLogo##', N'5B568D43-896F-4AF6-9089-2C69B83AA977','User company logo', @CompanyId, GETDATE(), @UserId, NULL))
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