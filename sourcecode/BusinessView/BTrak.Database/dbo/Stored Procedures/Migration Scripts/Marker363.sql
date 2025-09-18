CREATE PROCEDURE [dbo].[Marker363]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

	DECLARE @Currentdate DATETIME = GETDATE()
MERGE INTO [dbo].[HtmlTemplates] AS Target 
USING ( VALUES 
	(NEWID(),'KYCSubmissionTemplate',
'<!DOCTYPE html
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

</html>',GETDATE(),@UserId,@CompanyId)
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
INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) ;

	DECLARE @KYCSubmissionTemplateId UNIQUEIDENTIFIER = (SELECT Id From HtmlTemplates WHERE TemplateName = 'KYCSubmissionTemplate' AND CompanyId = @CompanyId)

	MERGE INTO [dbo].[HtmlTags] AS Target 
	USING ( VALUES
	        (NEWID(), N'##AddressLine1##',@KYCSubmissionTemplateId,'This is the client address line one of their locality', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##AddressLine2##',@KYCSubmissionTemplateId,'This is the client address line two of their locality', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##BusinessEmail##',@KYCSubmissionTemplateId,'This is the business email which is used in proforma invoice', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##BusinessNumber##',@KYCSubmissionTemplateId,'This is the business number which is used in proforma invoice', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##CompanyName##',@KYCSubmissionTemplateId,'This is the client company', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##CompanyWebsite##',@KYCSubmissionTemplateId,'This is the client website which belogs to client organization', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##Email##',@KYCSubmissionTemplateId,'This is the client email which is used sending any emails or for any other purpose', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##GstNumber##',@KYCSubmissionTemplateId,'his is the GST number which is used in proforma invoice', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##MobileNo##',@KYCSubmissionTemplateId,'This the primary contact number which is used contact purpose and sending SMS', @CompanyId, GETDATE(), @UserId, NULL)
	       ,(NEWID(), N'##Zipcode##',@KYCSubmissionTemplateId,'This is the client zip code of their locality', @CompanyId, GETDATE(), @UserId, NULL)
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

END