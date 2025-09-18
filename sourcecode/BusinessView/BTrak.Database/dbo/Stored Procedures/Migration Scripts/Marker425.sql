CREATE PROCEDURE [dbo].[Marker425]
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
	VALUES('UploadInvoicePdfMailToContracter','<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no">
<meta name="x-apple-disable-message-reformatting">
<meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Pdf upload</title>
<style type="text/css">
a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none
!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0
!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.
o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right
{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.
o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.
o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;
font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;
font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) 
format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;
font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) 
format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),
local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.
o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style>
</head>
<body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea">
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px">
<p style="margin-top:0;margin-bottom:0">
<a class="o_text-white" style="text-decoration:none;outline:0;color:#fff">
<img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none">
</a>
</p>
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px">
<table cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px">
<img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" 
width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none">
</td>
</tr>
<tr>
<td style="font-size:24px;line-height:24px;height:24px">&nbsp;
</td>
</tr>
</tbody>
</table>
<h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Pdf uploading for invoice
 - ##InvoiceNo## for ##ContractId##
</h2>
</td>
</tr>
</tbody>
</table>
<!--[if mso]>
<![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" 
style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px">
<div class="o_px-xs" style="padding-left:8px;padding-right:8px">
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;
</td>
</tr>
</tbody>
</table>
</div>
<p style="margin-top:0;margin-bottom:0">Hello,<br>Invoice is accepted by the SGTrader.Please upload the pdf for your next action.<br>Thank you.
</p>
</p>
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" 
style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px">
<p style="margin-top:0;margin-bottom:0">Click on link for further details</p>
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px">
<table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" 
style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px">
<a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View invoice
</a>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
</body>
</html>','Upload Pdf for invoice - ##InvoiceNo## for ##ContractId##',N'A26A6BD5-3BE4-422C-8272-D5088CF5D42B'),
('InvoicePdfMailToSGTrader','<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no">
<meta name="x-apple-disable-message-reformatting">
<meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Invoice pdf</title>
<style type="text/css">
a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none
!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0
!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.
o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right
{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.
o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.
o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;
font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;
font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) 
format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;
font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) 
format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),
local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.
o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style>
</head>
<body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea">
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px">
<p style="margin-top:0;margin-bottom:0">
<a class="o_text-white" style="text-decoration:none;outline:0;color:#fff">
<img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none">
</a>
</p>
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px">
<table cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px">
<img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" 
width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none">
</td>
</tr>
<tr>
<td style="font-size:24px;line-height:24px;height:24px">&nbsp;
</td>
</tr>
</tbody>
</table>
<h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Pdf for invoice
 - ##InvoiceNo## for ##ContractId##
</h2>
</td>
</tr>
</tbody>
</table>
<!--[if mso]>
<![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" 
style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px">
<div class="o_px-xs" style="padding-left:8px;padding-right:8px">
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;
</td>
</tr>
</tbody>
</table>
</div>
<p style="margin-top:0;margin-bottom:0">Hello,<br>Please find out the below pdf for invoice information.<br>Thank you.
</p>
</p>
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
</body>
</html>','View pdf for invoice information - ##InvoiceNo## for ##ContractId##',N'C2A7F3FB-4D7F-433B-A586-54D083543726'),
('InviceAcceptenceMailToSGTrader','<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no">
<meta name="x-apple-disable-message-reformatting">
<meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Invoice pdf</title>
<style type="text/css">
a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none
!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0
!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.
o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right
{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.
o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.
o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;
font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;
font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) 
format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;
font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) 
format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),
local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.
o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style>
</head>
<body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea">
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px">
<p style="margin-top:0;margin-bottom:0">
<a class="o_text-white" style="text-decoration:none;outline:0;color:#fff">
<img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none">
</a>
</p>
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px">
<table cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px">
<img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" 
width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none">
</td>
</tr>
<tr>
<td style="font-size:24px;line-height:24px;height:24px">&nbsp;
</td>
</tr>
</tbody>
</table>
<h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">Invoice Accepted
 - ##InvoiceNo## for ##ContractId##
</h2>
</td>
</tr>
</tbody>
</table>
<!--[if mso]>
<![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" 
style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px">
<div class="o_px-xs" style="padding-left:8px;padding-right:8px">
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;
</td>
</tr>
</tbody>
</table>
</div>
<p style="margin-top:0;margin-bottom:0">Hello,<br>Please find the invoice for your next action.<br>Thank you.
</p>
</p>
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" 
style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px">
<p style="margin-top:0;margin-bottom:0">Click on link for further details</p>
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px">
<table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" 
style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px">
<a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View invoice
</a>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
</body>
</html>','Invoice acceptence mail to SGTrader - ##InvoiceNo## for ##ContractId##',N'B589F613-8473-43D8-A622-0883F7785391'),
('ShareCreditOrDebitNoteToContracterEmailTemplate','<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no">
<meta name="x-apple-disable-message-reformatting">
<meta http-equiv="X-UA-Compatible" content="IE=edge"><title>Invoice pdf</title>
<style type="text/css">
a{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none
!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0
!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.
o_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right
{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.
o_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.
o_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;
font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;
font-weight:400;src:local("Roboto"),local("Roboto-Regular"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) 
format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;
font-style:normal;font-weight:700;src:local("Roboto Bold"),local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) 
format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local("Roboto Bold"),
local("Roboto-Bold"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.
o_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style>
</head>
<body class="o_body o_bg-light" style="width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea">
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_hide" align="center" style="display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden">Email Summary (Hidden)</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px">
<p style="margin-top:0;margin-bottom:0">
<a class="o_text-white" style="text-decoration:none;outline:0;color:#fff">
<img src="##CompanyLogo##" width="136" height="36" style="max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none">
</a>
</p>
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px">
<table cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px">
<img src="https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png" 
width="48" height="48" alt="" style="max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none">
</td>
</tr>
<tr>
<td style="font-size:24px;line-height:24px;height:24px">&nbsp;
</td>
</tr>
</tbody>
</table>
<h2 class="o_heading o_text-dark o_mb-xxs" style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px">##CreditOrDebitNote## Acceptence
 - ##InvoiceNo## for ##ContractId##
</h2>
</td>
</tr>
</tbody>
</table>
<!--[if mso]>
<![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" 
style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px">
<div class="o_px-xs" style="padding-left:8px;padding-right:8px">
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_re o_bt-light" style="font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0">&nbsp;
</td>
</tr>
</tbody>
</table>
</div>
<p style="margin-top:0;margin-bottom:0">Hello,<br>Please find the ##CreditOrDebitNote## for your next action.<br>Thank you.
</p>
</p>
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" 
style="font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px">
<p style="margin-top:0;margin-bottom:0">Click on link for further details</p>
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px">
<table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" 
style="font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px">
<a class="o_text-white" href="##siteUrl##" style="text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px">View ##CreditOrDebitNote##
</a>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
<tbody>
<tr>
<td class="o_bg-light o_px-xs" align="center" style="background-color:#dbe5ea;padding-left:8px;padding-right:8px">
<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width:632px;margin:0 auto">
<tbody>
<tr>
<td class="o_bg-white" style="font-size:48px;line-height:16px;height:16px;background-color:#fff">&nbsp;
</td>
</tr>
</tbody>
</table>
<!--[if mso]><![endif]-->
</td>
</tr>
</tbody>
</table>
</body>
</html>','##CreditOrDebitNote## Acceptence by contracter - ##InvoiceNo## for ##ContractId##',N'4F50C582-79C2-4837-9F6F-AD5D7260F0A1')
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
	        --Uploading invoice pdf mail to contracter
           (NEWID(), N'##ContractId##', N'A26A6BD5-3BE4-422C-8272-D5088CF5D42B', 'This is the Vessel ContractId', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##Quantity##', N'A26A6BD5-3BE4-422C-8272-D5088CF5D42B', 'This is the Quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##', N'A26A6BD5-3BE4-422C-8272-D5088CF5D42B', 'This is client registered company URL to login', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##InvoiceNo##', N'A26A6BD5-3BE4-422C-8272-D5088CF5D42B', 'This is invoice number', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'A26A6BD5-3BE4-422C-8272-D5088CF5D42B','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   --Invoice pdf mail to SGTrader
		   ,(NEWID(), N'##ContractId##', N'C2A7F3FB-4D7F-433B-A586-54D083543726', 'This is the Vessel ContractId', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##Quantity##', N'C2A7F3FB-4D7F-433B-A586-54D083543726', 'This is the Quantity', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##', N'C2A7F3FB-4D7F-433B-A586-54D083543726', 'This is client registered company URL to login', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##InvoiceNo##', N'C2A7F3FB-4D7F-433B-A586-54D083543726', 'This is invoice number', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'C2A7F3FB-4D7F-433B-A586-54D083543726','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   --Invoice conformation mail to SGTrader
		   ,(NEWID(), N'##ContractId##', N'C2A7F3FB-4D7F-433B-A586-54D083543726', 'This is the Vessel ContractId', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##', N'C2A7F3FB-4D7F-433B-A586-54D083543726', 'This is client registered company URL to login', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##InvoiceNo##', N'C2A7F3FB-4D7F-433B-A586-54D083543726', 'This is invoice number', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'C2A7F3FB-4D7F-433B-A586-54D083543726','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL)
		   --Sharing CreditOrDebit Note email to contracter
		   ,(NEWID(), N'##ContractId##', N'4F50C582-79C2-4837-9F6F-AD5D7260F0A1', 'This is the Vessel ContractId', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CreditOrDebitNote##', N'4F50C582-79C2-4837-9F6F-AD5D7260F0A1', 'This is the text indicating wheather a credit or debit note', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##', N'4F50C582-79C2-4837-9F6F-AD5D7260F0A1', 'This is client registered company URL to login', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##InvoiceNo##', N'4F50C582-79C2-4837-9F6F-AD5D7260F0A1', 'This is invoice number', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'4F50C582-79C2-4837-9F6F-AD5D7260F0A1','This is the company logo used to send email', @CompanyId, GETDATE(), @UserId, NULL))
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

	UPDATE HtmlTemplates SET HtmlTemplate = '<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>MGV COMMODITY PTE LTD
</title>
<style>body{background-color:#f6f6f6;margin:0;padding:0;font-family:Verdana,Geneva,sans-serif;font-style:normal;font-variant:normal}h1,h2,h3,h4,h5,h6{margin:0;padding:0}p{margin:0;padding:0}.
container{width:80%;margin-right:auto;margin-left:auto}.row{display:flex;flex-wrap:wrap}.col-6{width:50%;flex:0 0 auto}.col-4{width:30%;flex:0 0 auto}.col-3{width:23%;flex:0 0 auto}.
col-8{width:74%;flex:0 0 auto}.col-12{width:100%;flex:0 0 auto}.body-section{padding:80px}.sub-heading{color:#262626}
</style>
</head>
<body>
<div class="container">
<div class="body-section">
<div class="row">
<div class="col-12">
<p class="sub-heading" style="text-align:center;color:red;font-size:40px">MGV COMMODITY PTE LTD
</p>
<p class="sub-heading" style="text-align:center;font-weight:600">77 HIGH STREET #4-11 HIGH STREET PLAZA, SINGAPORE 179433
</p>
<p class="sub-heading" style="text-align:center">Registration No. 201618435E PHONE +65-63362665
</p>
</div>
</div>
<div class="row">
<div class="col-12" style="margin-top:20px">
<p class="sub-heading" style="font-weight:600;text-decoration:underline;text-align:center;font-size:16px">COMMERCIAL INVOICE
</p>
</div>
</div>
<div class="row">
<div class="col-6" style="margin-top:10px">
<p class="sub-heading" style="font-weight:600;font-size:14px">No : ##InvoiceNumber##
</p></div><div class="col-6" style="margin-top:10px">
<p class="sub-heading" style="font-weight:600;float:right;font-size:14px">Date : ##IssueDate##
</p>
</div>
</div>
<div class="row">
<div class="col-12" style="margin-top:5px">
<p class="sub-heading" style="font-weight:600;font-size:14px">Buyer: ##ClientName##
</p>
<p class="sub-heading" style="font-weight:600;font-size:14px">##ClientAddressLine1##</p>
<p class="sub-heading" style="font-weight:600;font-size:14px">##ClientAddressLine2##</p>
<p class="sub-heading" style="font-weight:600;font-size:14px">##IECCodeAndMailIdText##</p>
</div>
</div>
<div class="row">
<div class="col-12">
<hr style="background:#000">
</div>
</div>
<div class="row">
<div class="col-12">
<table>
<tr>
<td style="padding-bottom:10px;font-size:14px">PORT OF LOADING</td>
<td style="padding-bottom:10px;font-size:14px;padding-left:600px">: ##PortLoad##</td>
</tr>
<tr>
<td style="padding-bottom:10px;font-size:14px">PORT OF DISCHARGE</td>
<td style="padding-bottom:10px;font-size:14px;padding-left:600px">: ##PortDischarge##</td
</tr>
<tr>
<td style="padding-bottom:10px;font-size:14px">B/L NO. & DATE<br><br></td>
<td style="padding-bottom:10px;font-size:14px;padding-left:600px">: ##BLNoAndDate##</td>
</tr>
<tr>
<td style="padding-bottom:10px;font-size:14px">NAME OF VESSEL</td>
<td style="padding-bottom:10px;font-size:14px;padding-left:600px">: ##VesselName##</td>
</tr>
<tr>
<td style="padding-bottom:10px;font-size:14px">PAYMENT TERMS</td>
<td style="padding-bottom:10px;font-size:14px;padding-left:600px">: ##PaymentTerms##</td></tr>
<tr>
<td style="padding-bottom:10px;font-size:14px">DRAWEE''S BANK</td>
<td style="padding-bottom:10px;font-size:14px;padding-left:600px">: ##DraweesBank##</td>
</tr>
</table>
</div>
</div>
<div class="row">
<div class="col-12">
<hr style="background:#000"></div></div>
<div class="row"><div class="col-4" style="font-size:14px;text-align:center;font-weight:600">
<p class="sub-heading">DESCRIPTION OF GOODS</p></div>
<div class="col-3" style="font-size:14px;font-weight:600">
<p class="sub-heading">QUANTITY MT</p></div>
<div class="col-3" style="font-size:14px;font-weight:600">
<p class="sub-heading">UNIT PRICE (USD)<br>CFR HALDIA, INDIA</p></div>
<div class="col-3" style="font-size:14px;font-weight:600">
<p class="sub-heading">AMOUNT (USD)</p></div></div>
<div class="row"><div class="col-12">
<hr style="background:#000"></div></div>
<div class="row">
<div class="col-4" style="font-size:14px;font-weight:600">
<p class="sub-heading">##CommodityName##</p></div>
<div class="col-3" style="font-size:14px;font-weight:600">
<p class="sub-heading">##Quantity##</p></div>
<div class="col-3" style="font-size:14px;font-weight:600">
<p class="sub-heading">##UnitPrice##</p></div>
<div class="col-3" style="font-size:14px;font-weight:600">
<p class="sub-heading">##Amount##</p></div></div></div>
<div class="row" style="margin-top:20px">
<div class="col-4" style="font-size:14px;font-weight:600">
<p class="sub-heading" style="text-align:center">TOTAL QTY</p></div>
<div class="col-3" style="font-size:14px;font-weight:600">
<p class="sub-heading" style="border-top-style:dotted;border-bottom-style:dotted;padding:10px">##Quantity##</p></div>
<div class="col-3" style="font-size:14px;font-weight:600"></div>
<div class="col-3" style="font-size:14px;font-weight:600"></div></div>
<div class="row" style="margin-top:20px">
<div class="col-4">
<p class="sub-heading" style="font-weight:600;font-size:13px">WE CERTIFY:</p>
<p class="sub-heading" style="font-size:12px">A) THAT IMPORT IS NOT UNDER NEGATIVE LIST AND FREELY IMPORTABLE AS PER INDIA''S FOREGIN TRADE POLICY 2022</p>
<p class="sub-heading" style="font-size:12px;margin-top:10px">B) THAT THE OIL IS FREE FROM CONMTAMINATION AND SEA WATER AT THE TIME OF SHIPMENT AND THIS CONSIGNMENT DOES NOT CONTAIN BEEF IN ANY FORM</p>
<p class="sub-heading" style="font-size:12px;margin-top:10px">C) THAT THE FREIGHT CHARGED FOR THIS SHIPMENT IS USD 50 PER MT</p>
<p class="sub-heading" style="font-size:12px;margin-top:10px">D) THE GOODS ARE OF PAPUA NEW GUINEA ORIGIN</p>
<p class="sub-heading" style="font-size:12px;margin-top:10px;font-weight:600">QUALITY SPECIFICATION</p>
<p class="sub-heading" style="font-size:12px;margin-top:10px;text-decoration:underline;font-weight:600">TERMS</p>
<p class="sub-heading" style="font-size:12px;margin-top:10px">FFA 4.5% MAX</p>
<p class="sub-heading" style="font-size:12px;margin-top:10px">MN 0.5% MAX</p></div>
<div class="col-3" style="font-size:14px;font-weight:600"></div>
<div class="col-3" style="font-size:14px;font-weight:600"></div>
<div class="col-3" style="font-size:14px;font-weight:600"></div></div>
<div class="row" style="margin-top:20px">
<div class="col-4" style="font-size:14px;font-weight:600">
<p class="sub-heading">TOTAL INVOICE VALUE US$</p></div>
<div class="col-3" style="font-size:14px;font-weight:600"></div>
<div class="col-3" style="font-size:14px;font-weight:600"></div>
<div class="col-3" style="font-size:14px;font-weight:600">
<p class="sub-heading" style="border-top-style:dotted;border-bottom-style:dotted;padding:10px">##Amount##</p></div></div>
<div class="row"><div class="col-12" style="margin-top:10px">
<p class="sub-heading" style="font-weight:600;font-size:12px">##AmountinWords##</p>
<hr style="background:#000">
<p class="sub-heading" style="font-size:12px;font-weight:600">Payment by Telegraphic Transfer to our account as under:</p></div></div>
<div class="row"><div class="col-12">
<table>
<tr>
<td style="padding-bottom:10px;font-size:14px">Bank Name</td>
<td style="padding-bottom:10px;font-size:14px">: HSBC LIMITED, 9 Battery Road #12-01 MYP Centre, SINGAPORE 049910</td></tr>
<tr>
<td style="padding-bottom:10px;font-size:14px">Swift Code</td>
<td style="padding-bottom:10px;font-size:14px">: HSBCSGSG</td></tr>
<tr>
<td style="padding-bottom:10px;font-size:14px">Branch Code</td>
<td style="padding-bottom:10px;font-size:14px">: 7232</td></tr>
<tr>
<td style="padding-bottom:10px;font-size:14px">Account Name</td>
<td style="padding-bottom:10px;font-size:14px">: MGV COMMODITY PTE LTD</td></tr>
<tr>
<td style="padding-bottom:10px;font-size:14px">Accont Number(USD)</td>
<td style="padding-bottom:10px;font-size:14px;font-weight:600">: 25637373889</td></tr></table></div></div>
<div class="row">
<div class="col-12" style="margin-top:10px">
<p class="sub-heading" style="font-weight:600;font-style:italic">Please Quote Invoice number in the description filed of the remittance</p>
<hr style="background:#000"></div></div><div class="row"><div class="col-12"><p class="sub-heading" style="font-weight:600;font-size:16px">MGV COMMODITIY PTE LTD</p></div></div>
<div class="row">
<div class="col-12" style="margin-top:70px">
<p class="sub-heading" style="font-weight:600;font-size:14px">AUTHORISED SIGNATORY</p>
</div>
</div>
</div>
</body>
</html>' WHERE TemplateName = 'InvoiceAcceptanceBySgtraderEmailTemplateofCBInvoice'

UPDATE EmailTemplates SET EmailTemplate = '<!DOCTYPE html>  
<html lang="en">
   <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>MGV COMMODITY PTE LTD</title>
      <style>          body{              background-color: #F6F6F6;               margin: 0;              padding: 0;              font-family: Verdana, Geneva, sans-serif;              font-style: normal; font-variant: normal;          }          #pageborder {              position: fixed;              left: 0;              right: 0;              top: 0;              bottom: 0;          }            @page {              margin: 1.5cm;                @top-center {                  content: element(pageHeader);              }                @bottom-center {                  content: element(pageFooter);              }          }            #pageHeader {              position: running(pageHeader);          }            #pageFooter {              position: running(pageFooter);          }          h1,h2,h3,h4,h5,h6{              margin: 0;              padding: 0;          }          p{              margin: 0;              padding: 0;          }          .container{              width: 95%;              margin-right: auto;              margin-left: auto;          }          .row{              display: flex;              flex-wrap: wrap;          }          .col-6{              width: 50%;              flex: 0 0 auto;          }          .col-4{              width: 25%;              flex: 0 0 auto;          }          .col-8{              width: 74%;              flex: 0 0 auto;          }          .col-12{              width: 100%;              flex: 0 0 auto;          }          .sub-heading{              color: #262626;              margin-bottom: 05px;          }      </style>
   </head>
   <body>
      <div class="container">
         <div id="pageborder">          </div>
         <div class="body-section">
            <div class="row">
               <div class="col-12">
                  <p class="sub-heading" style="text-align: center; color: red; font-size: 40px;">MGV COMMODITY PTE LTD</p>
                  <p class="sub-heading" style="text-align: center; font-weight: 600;">77 HIGH STREET #4-11 HIGH STREET PLAZA, SINGAPORE 179433</p>
                  <p class="sub-heading" style="text-align: center;">Registration No. 201618435E PHONE +65-63362665</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 30px;">
                  <p class="sub-heading" style="font-weight: 600;">DATE : ##CurrentDate#</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 30px;">
                  <p class="sub-heading" style="font-weight: 600; text-decoration: underline; text-align: center;">FREIGHT CERTIFICATE</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 30px;">
                  <p class="sub-heading" style="font-weight: 600; text-decoration: underline;">TO WHOM IT MAY CONCERN</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 20px;">
                  <table>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">VESSEL</td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##VesselName##</td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">GOODS</td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##CommodityName##</td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">PORT OF LOADING</td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##CountryName##</td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">PORT OF DISCHARGE</td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##PortOfDischarge##</td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">BILL OD LANDING OF DATE<br><br></td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##BillOfLanding##                                  <br><span style="margin-left: 10px;">##BillOfLanding##</span>                              </td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">QUANTITY IN MTS</td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##QuantityUnits##</td>
                     </tr>
                  </table>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 30px;">
                  <p class="sub-heading" style="font-weight: 600;">===========================================================</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 20px;">
                  <p class="sub-heading" style="font-weight: 600;">WE HERE BY CERTIFY THAT FREIGHT ON THIS SHIPMENT IS USD 50 USD ON FIXED QTY OF #10,000#</p>
                  <p class="sub-heading" style="font-weight: 600;">MT FRIEGHT AMOUNT PAID WAS USD ##freightInWords## ONLY</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 70px;">
                  <p class="sub-heading" style="font-weight: 600; font-size: 20px;">MGV COMMODITIY PTE LTD</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 70px;">
                  <p class="sub-heading" style="font-weight: 600; font-size: 20px;">AUTHORISED SIGNATORY</p>
               </div>
            </div>
			 </div>
		 		 <div class="row">
               <div class="col-12" style="margin-top:70px">
                    ##UserStampHTML##
               </div>
           </div>
         </div>
      </div>
   </body>
</html>' WHERE EmailTemplateName = 'FreightCertificatePdfTemplate' AND CompanyId = @CompanyId

UPDATE EmailTemplates SET EmailTemplate = '<!DOCTYPE html>  
<html lang="en">
   <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>MGV COMMODITY PTE LTD</title>
      <style>          body{              background-color: #F6F6F6;               margin: 0;              padding: 0;              font-family: Verdana, Geneva, sans-serif;              font-style: normal; font-variant: normal;          }          #pageborder {              position: fixed;              left: 0;              right: 0;              top: 0;              bottom: 0;          }            @page {              margin: 1.5cm;                @top-center {                  content: element(pageHeader);              }                @bottom-center {                  content: element(pageFooter);              }          }            #pageHeader {              position: running(pageHeader);          }            #pageFooter {              position: running(pageFooter);          }          h1,h2,h3,h4,h5,h6{              margin: 0;              padding: 0;          }          p{              margin: 0;              padding: 0;          }          .container{              width: 95%;              margin-right: auto;              margin-left: auto;          }          .row{              display: flex;              flex-wrap: wrap;          }          .col-6{              width: 50%;              flex: 0 0 auto;          }          .col-4{              width: 25%;              flex: 0 0 auto;          }          .col-8{              width: 74%;              flex: 0 0 auto;          }          .col-12{              width: 100%;              flex: 0 0 auto;          }          .sub-heading{              color: #262626;              margin-bottom: 05px;          }      </style>
   </head>
   <body>
      <div class="container">
         <div id="pageborder">          </div>
         <div class="body-section">
            <div class="row">
               <div class="col-12">
                  <p class="sub-heading" style="text-align: center; color: red; font-size: 40px;">MGV COMMODITY PTE LTD</p>
                  <p class="sub-heading" style="text-align: center; font-weight: 600;">77 HIGH STREET #4-11 HIGH STREET PLAZA, SINGAPORE 179433</p>
                  <p class="sub-heading" style="text-align: center;">Registration No. 201618435E PHONE +65-63362665</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 30px;">
                  <p class="sub-heading" style="font-weight: 600;">DATE : #22/04/2022#</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 30px;">
                  <p class="sub-heading" style="font-weight: 600; text-decoration: underline; text-align: center;">SHELF LIFE CERTIFICATE</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 30px;">
                  <p class="sub-heading" style="font-weight: 600; text-decoration: underline;">TO WHOM IT MAY CONCERN</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 20px;">
                  <table>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">VESSEL</td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##VesselName##</td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">GOODS</td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##CommodityName##</td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">PORT OF LOADING</td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##CountryName##</td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">PORT OF DISCHARGE</td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##PortOfDischarge##</td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">BILL OD LANDING OF DATE<br><br></td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##BillOfLanding##                                  <br><span style="margin-left: 10px;">##BillOfLanding##</span>                              </td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">QUANTITY IN MTS</td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##QuantityUnits##</td>
                     </tr>
                  </table>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 30px;">
                  <p class="sub-heading" style="font-weight: 600;">===========================================================</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 20px;">
                  <p class="sub-heading" style="font-weight: 600;">WE HERE BY CERTIFY THAT SHELF LIFE OF THIS CONSIGNMENT OF CRUDE PALM OIL</p>
                  <p class="sub-heading" style="font-weight: 600;">(EDIBLE GRADE) IN BULK IS OF ONE YEAR AS FOLLOWS: </p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 20px;">
                  <table>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">DATE OF MANUFATURE</td>
                        <td style="padding-bottom: 10px; font-weight: 600; padding-left: 40px;">: ##ManufactureDate##</td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">DATE OF EXPIRY</td>
                        <td style="padding-bottom: 10px; font-weight: 600; padding-left: 40px;">: ##ExpiryDate##</td>
                     </tr>
                  </table>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 70px;">
                  <p class="sub-heading" style="font-weight: 600; font-size: 20px;">MGV COMMODITIY PTE LTD</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 70px;">
                  <p class="sub-heading" style="font-weight: 600; font-size: 20px;">AUTHORISED SIGNATORY</p>
               </div>
            </div>
			</div>
		 		 <div class="row">
               <div class="col-12" style="margin-top:70px">
                    ##UserStampHTML##
               </div>
           </div>
         </div>
      </div>
   </body>
</html>'  WHERE EmailTemplateName = 'ShelfLifeCertificatePdfTemplate' AND CompanyId = @CompanyId

UPDATE EmailTemplates SET EmailTemplate = '<!DOCTYPE html>  
<html lang="en">
   <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>MGV COMMODITY PTE LTD</title>
      <style>          body{              background-color: #F6F6F6;               margin: 0;              padding: 0;              font-family: Verdana, Geneva, sans-serif;              font-style: normal; font-variant: normal;          }           #pageborder {              position: fixed;              left: 0;              right: 0;              top: 0;              bottom: 0;          }            @page {              margin: 1.5cm;                @top-center {                  content: element(pageHeader);              }                @bottom-center {                  content: element(pageFooter);              }          }            #pageHeader {              position: running(pageHeader);          }            #pageFooter {              position: running(pageFooter);          }            h1,h2,h3,h4,h5,h6{              margin: 0;              padding: 0;          }          p{              margin: 0;              padding: 0;          }          .container{              width: 95%;              margin-right: auto;              margin-left: auto;          }          .row{              display: flex;              flex-wrap: wrap;          }          .col-6{              width: 50%;              flex: 0 0 auto;          }          .col-4{              width: 25%;              flex: 0 0 auto;          }          .col-8{              width: 74%;              flex: 0 0 auto;          }          .col-12{              width: 100%;              flex: 0 0 auto;          }          .sub-heading{              color: #262626;              margin-bottom: 05px;          }      </style>
   </head>
   <body>
      <div class="container">
         <div id="pageborder">          </div>
         <div class="body-section">
            <div class="row">
               <div class="col-12">
                  <p class="sub-heading" style="text-align: center; color: red; font-size: 40px;">MGV COMMODITY PTE LTD</p>
                  <p class="sub-heading" style="text-align: center; font-weight: 600;">77 HIGH STREET #4-11 HIGH STREET PLAZA, SINGAPORE 179433</p>
                  <p class="sub-heading" style="text-align: center;">Registration No. 201618435E PHONE +65-63362665</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 30px;">
                  <p class="sub-heading" style="font-weight: 600;">DATE : ##CurrentDate##</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 30px;">
                  <p class="sub-heading" style="font-weight: 600; text-decoration: underline; text-align: center;">CERTIFICATE OF ORIGIN</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 30px;">
                  <p class="sub-heading" style="font-weight: 600; text-decoration: underline;">TO WHOM IT MAY CONCERN</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 20px;">
                  <table>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">VESSEL</td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##VesselName##</td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">GOODS</td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##CommodityName##</td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">PORT OF LOADING</td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##CountryName##</td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">PORT OF DISCHARGE</td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: #PortOfDischarge#</td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">BILL OD LANDING OF DATE<br><br></td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##BillOfLanding##                                  <br><span style="margin-left: 10px;">##BillOfLanding##</span>                              </td>
                     </tr>
                     <tr>
                        <td style="padding-bottom: 10px; font-weight: 600;">QUANTITY IN MTS</td>
                        <td style="padding-bottom: 10px; font-weight: 600;">: ##QuantityUnits##</td>
                     </tr>
                  </table>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 30px;">
                  <p class="sub-heading" style="font-weight: 600;">===========================================================</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 20px;">
                  <p class="sub-heading" style="font-weight: 600;">WE HERE BY CERTIFY THAT THIS CONSIGNMENT OF GRADE PALMKERNEL OLI (EDIBLE GRADE) IN</p>
                  <p class="sub-heading" style="font-weight: 600;">BULKS IS OF PAPUA NEW GUINEA ORIGIN.</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 70px;">
                  <p class="sub-heading" style="font-weight: 600; font-size: 20px;">MGV COMMODITIY PTE LTD</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top: 70px;">
                  <p class="sub-heading" style="font-weight: 600; font-size: 20px;">AUTHORISED SIGNATORY</p>
               </div>
            </div>
			</div>
		 		 <div class="row">
               <div class="col-12" style="margin-top:70px">
                    ##UserStampHTML##
               </div>
           </div>
         </div>
      </div>
   </body>
</html>'  WHERE EmailTemplateName = 'CertificateOfOriginPdfTemplate' AND CompanyId = @CompanyId

UPDATE EmailTemplates SET EmailTemplate = '<!DOCTYPE html>  
<html lang="en">
   <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width,initial-scale=1">
      <title>LOT Switching BL</title>
      <style>      #pageborder {              position: fixed;              left: 0;              right: 0;              top: 0;              bottom: 0;          }            @page {              margin: 1.5cm;                @top-center {                  content: element(pageHeader);              }                @bottom-center {                  content: element(pageFooter);              }          }            #pageHeader {              position: running(pageHeader);          }            #pageFooter {              position: running(pageFooter);          }            body {              background-color: #f6f6f6;              margin: 0;              padding: 0;              font-family: Verdana, Geneva, sans-serif;              font-style: normal;              font-variant: normal          }            h1,          h2,          h3,          h4,          h5,          h6 {              margin: 0;              padding: 0          }            p {              margin: 0;              padding: 0          }            .container {              width: 95%;              margin-right: auto;              margin-left: auto          }            .row {              display: flex;              flex-wrap: wrap          }            .col-6 {              width: 50%;              flex: 0 0 auto          }            .col-4 {              width: 33%;              flex: 0 0 auto          }            .col-8 {              width: 74%;              flex: 0 0 auto          }            .col-3 {              width: 20%;              flex: 0 0 auto          }            .col-9 {              width: 80%;              flex: 0 0 auto          }            .col-12 {              width: 100%;              flex: 0 0 auto          }            .sub-heading {              color: #262626;              margin-bottom: 5px;              font-size: 14px          }            span {              color: #00f          }            .col-1 {              width: 10%;              flex: 0 0 auto          }            .col-custom-4 {              width: 53%;              flex: 0 0 auto          }      </style>
   </head>
   <body>
      <div class="container">
         <div id="pageborder">          </div>
         <div class="body-section">
            <div class="row">
               <div class="col-12" style="margin-top:30px">
                  <p class="sub-heading" style="font-weight:600;font-size:18px;text-decoration:underline">STANDARD                          FORM LETTER OF INDEMNITY TO BE GIVEN IN RETURN FOR SWITCHING BILL OF LADING</p>
               </div>
            </div>
            <div class="row">
               <div class="col-1" style="margin-top:20px">
                  <p class="sub-heading">To:</p>
               </div>
               <div class="col-custom-4" style="margin-top:20px">
                  <p class="sub-heading">##ToAddress##</p>
               </div>
               <div class="col-4" style="margin-top:20px">
                  <p class="sub-heading">##ToDate##</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:20px">
                  <p class="sub-heading">Dear Sirs</p>
               </div>
            </div>
            <div class="row">
               <div class="col-3">
                  <p class="sub-heading" style="margin-bottom:15px">Description</p>
               </div>
               <div class="col-9">
                  <p class="sub-heading" style="margin-bottom:15px">: ##1stDescription##</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12">
                  <p class="sub-heading">1st set B/L description</p>
               </div>
            </div>
            <div class="row">
               <div class="col-3">
                  <p class="sub-heading" style="margin-bottom:15px">1) Shipper</p>
                  <p class="sub-heading" style="margin-bottom:15px">Consignee</p>
                  <p class="sub-heading" style="margin-bottom:15px">Notify party</p>
                  <p class="sub-heading" style="margin-bottom:15px">Loadport</p>
                  <p class="sub-heading" style="margin-bottom:15px">Disport</p>
                  <p class="sub-heading" style="margin-bottom:15px;color:red">B/L NO</p>
                  <p class="sub-heading" style="margin-bottom:15px">B/L Date</p>
                  <p class="sub-heading" style="margin-bottom:15px">B/L Quantity</p>
               </div>
               <div class="col-9">
                  <p class="sub-heading" style="margin-bottom:15px">: ##Shipper1##</p>
                  <p class="sub-heading" style="margin-bottom:15px">: ##Consignee1##</p>
                  <p class="sub-heading" style="margin-bottom:15px">: ##NotifyPrty1##</p>
                  <p class="sub-heading" style="margin-bottom:15px">: ##LoadPort1##</p>
                  <p class="sub-heading" style="margin-bottom:15px">: ##DischargePort1##</p>
                  <p class="sub-heading" style="margin-bottom:15px;color:red">: ##BLNO1##</p>
                  <p class="sub-heading" style="margin-bottom:15px">: ##BLDate1##</p>
                  <p class="sub-heading" style="margin-bottom:15px">: ##BLQuantity1##</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12">
                  <p class="sub-heading">The above cargo was shipped on the above ship by ##ShipBy1## and consigned to                          ##ConsignedTo1## for delivery at the port of ##PortOfDelivery1##</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:20px">
                  <p class="sub-heading">We, ##HereByName##, hereby request you to change the Bill of Lading at the                          loading port with new set as per our above instruction via ##SwitchBlAgent## in ##Country## AS                          AT ##PortOfLoading1##</p>
               </div>
            </div>
            <div class="row">
               <div class="col-3" style="margin-top:30px">
                  <p class="sub-heading" style="margin-bottom:15px">Description</p>
               </div>
               <div class="col-9" style="margin-top:30px">
                  <p class="sub-heading" style="margin-bottom:15px">: ##2ndDescription##</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12">
                  <p class="sub-heading">2nd set B/L description</p>
               </div>
            </div>
            <div class="row">
               <div class="col-3">
                  <p class="sub-heading" style="margin-bottom:15px">2) Shipper</p>
                  <p class="sub-heading" style="margin-bottom:15px">Consignee</p>
                  <p class="sub-heading" style="margin-bottom:15px">Notify party</p>
                  <p class="sub-heading" style="margin-bottom:15px">Loadport</p>
                  <p class="sub-heading" style="margin-bottom:15px">Disport</p>
                  <p class="sub-heading" style="margin-bottom:15px;color:red">B/L NO</p>
                  <p class="sub-heading" style="margin-bottom:15px">B/L Date</p>
                  <p class="sub-heading" style="margin-bottom:15px">B/L Quantity</p>
               </div>
               <div class="col-9">
                  <p class="sub-heading" style="margin-bottom:15px">: ##Shipper2##</p>
                  <p class="sub-heading" style="margin-bottom:15px">: ##Consignee2##</p>
                  <p class="sub-heading" style="margin-bottom:15px">: ##NotifyPrty2##</p>
                  <p class="sub-heading" style="margin-bottom:15px">: ##LoadPort2##</p>
                  <p class="sub-heading" style="margin-bottom:15px">: ##DischargePort2##</p>
                  <p class="sub-heading" style="margin-bottom:15px;color:red">: ##BLNO2##</p>
                  <p class="sub-heading" style="margin-bottom:15px">: ##BLDate2##</p>
                  <p class="sub-heading" style="margin-bottom:15px">: ##BLQuantity2##</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12">
                  <p class="sub-heading">The above cargo was shipped on the above ship by ##ShipBy2## and consigned to                          ##ConsignedTo2## for delivery at the port of ##PortOfDelivery2##</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:20px">
                  <p class="sub-heading">We, ##HereByName##, hereby request you to change the Bill of Lading at the                          loading port with new set as per our above instruction via ##SwitchBlAgent## in ##Country## AS                          AT ##PortOfLoading2##</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:20px">
                  <p class="sub-heading">In consideration of your complying with our above request, we hereby agree as                          follows:</p>
                  <p class="sub-heading">1. To indemnify you, your servants and agents and to hold all of you harmless                          in respect of any liability, loss, damage or expense of whatsoever nature which you may sustain                          by reason of the changing bills of lading and delivering the cargo in accordance with our                          request</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:20px">
                  <p class="sub-heading">2. In the event of any proceedings being commenced against you or any of your                          servants or agents in connection with the delivery of the cargo as aforesaid to provide you or                          them on demand with sufficient funds to defend the same</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:20px">
                  <p class="sub-heading">3. If, in connection with the delivery of the cargo as aforesaid, the ship or                          any other ship or property belonging to you in the same or associated ownership, management or                          control, should be arrested or detained or should the arrest or detention thereof be threatened,                          or should there be any interference in the use or trading of the vessel (whether by virtue of a                          caveat being entered on the ship’s registry or otherwise howsoever), to provide on demand such                          bail or other security as may be required to prevent such arrest or detention or to secure the                          release of such ship or property or to remove such interference and to indemnify you in respect                          of any liability, loss, damage or expense caused by such arrest or detention or threatened                          arrest or detention or such interference, whether or not such arrest or detention or threatened                          arrest or detention or such interference may be justified.</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:20px">
                  <p class="sub-heading">4. If the place at which we have asked you to make delivery is a bulk liquid                          or gas terminal or facility, or another ship, lighter or barge, then delivery to such terminal,                          facility, ship. Lighter or barge shall be deemed to be delivery to the party to whom we have                          requested you to make such delivery.</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:20px">
                  <p class="sub-heading">5. As soon as all original Bills of Lading for the above cargo shall have                          come into our possession, to deliver the same to you, or otherwise to cause all original Bills                          of Lading to be delivered to you, whereupon our liability hereunder shall cease.</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:20px">
                  <p class="sub-heading">6. The liability of each and every person under this indemnity shall be joint                          and several and shall not be conditional upon your proceeding first against any person, whether                          or not such person is party to or liable under this indemnity.</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:20px">
                  <p class="sub-heading">7. This indemnity shall be governed by and construed in accordance with                          [English] law and each and every person liable under this indemnity shall at your request submit                          to the jurisdiction of the High Court of Justice of [London]</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:20px">
                  <p class="sub-heading">Yours faithfully,</p>
                  <p class="sub-heading">For and on behalf of</p>
                  <p class="sub-heading" style="font-style:italic">##BehalfCompanyName##</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:20px">
                  <p class="sub-heading">.......................................</p>
                  <p class="sub-heading">##Signature##</p>
				 
               </div>
            </div>
			<div class="row">
                 <div class="col-12" style="margin-top:70px">
                      ##UserStampHTML##
                 </div>
            </div>
         </div>
      </div>
   </body>
</html>'  WHERE EmailTemplateName = 'LOIBLPdfTemplate' AND CompanyId = @CompanyId

UPDATE EmailTemplates SET EmailTemplate = '<!DOCTYPE html>  
<html lang="en">
   <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width,initial-scale=1">
      <title>LOI For Discharging Cargo</title>
      <style>          body {              background-color: #f6f6f6;              margin: 0;              padding: 0;              font-family: Verdana, Geneva, sans-serif;              font-style: normal;              font-variant: normal          }          #pageborder {              position: fixed;              left: 0;              right: 0;              top: 0;              bottom: 0;          }            @page {              margin: 1.5cm;                @top-center {                  content: element(pageHeader);              }                @bottom-center {                  content: element(pageFooter);              }          }            #pageHeader {              position: running(pageHeader);          }            #pageFooter {              position: running(pageFooter);          }            h1,          h2,          h3,          h4,          h5,          h6 {              margin: 0;              padding: 0          }            p {              margin: 0;              padding: 0          }            .container {              width: 95%;              margin-right: auto;              margin-left: auto          }            .row {              display: flex;              flex-wrap: wrap          }            .col-6 {              width: 50%;              flex: 0 0 auto          }            .col-4 {              width: 25%;              flex: 0 0 auto          }            .col-8 {              width: 74%;              flex: 0 0 auto          }            .col-3 {              width: 20%;              flex: 0 0 auto          }            .col-9 {              width: 80%;              flex: 0 0 auto          }            .col-12 {              width: 100%;              flex: 0 0 auto          }            .sub-heading {              color: #262626;              margin-bottom: 5px          }            span {              color: #00f          }      </style>
   </head>
   <body>
      <div class="container">
         <div id="pageborder">          </div>
         <div class="body-section">
            <div class="row">
               <div class="col-12" style="margin-top:30px">
                  <p class="sub-heading" style="font-weight:600;font-size:22px;font-family:''DM Serif Display'',serif">                          INT GROUP A</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:30px">
                  <p class="sub-heading" style="font-weight:600">Standard form Letter of Indemnity to be given in                          return for delivering cargo without production of the original Bill of Lading</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:40px">
                  <p class="sub-heading" style="text-align:center;font-style:italic">##Date##</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:40px">
                  <p class="sub-heading">Dear Sirs</p>
               </div>
            </div>
            <div class="row">
               <div class="col-3" style="margin-top:30px">
                  <p class="sub-heading" style="margin-bottom:15px">AA.Ship :</p>
                  <p class="sub-heading" style="margin-bottom:15px">Voyage :</p>
                  <p class="sub-heading" style="margin-bottom:15px">Cargo :</p>
                  <p class="sub-heading" style="margin-bottom:15px">Bill of lading :</p>
                  <p class="sub-heading" style="margin-bottom:15px">BB.Ship :</p>
                  <p class="sub-heading" style="margin-bottom:15px">Voyage :</p>
                  <p class="sub-heading" style="margin-bottom:15px">Cargo :</p>
                  <p class="sub-heading" style="margin-bottom:15px">Bill of lading :</p>
                  <p class="sub-heading" style="margin-bottom:15px">CC.Ship :</p>
                  <p class="sub-heading" style="margin-bottom:15px">Voyage :</p>
                  <p class="sub-heading" style="margin-bottom:15px">Cargo :</p>
                  <p class="sub-heading" style="margin-bottom:15px">Bill of lading :</p>
               </div>
               <div class="col-9" style="margin-top:30px">
                  <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Ship##</p>
                  <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Voyage##</p>
                  <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Cargo##</p>
                  <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##BillOfLadingAAShip##</p>
                  <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Ship##</p>
                  <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Voyage##</p>
                  <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Cargo##</p>
                  <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##BillOfLadingBBShip##</p>
                  <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Ship##</p>
                  <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Voyage##</p>
                  <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Cargo##</p>
                  <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##BillOfLadingCCShip##</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:20px">
                  <p class="sub-heading" style="font-size:14px">The above cargo was shipped on the above ship                          by<span>##ShippedBy##</span>and consigned to<span>##ConsignedTo##</span>for delivery at the port                          of<span>##PortOfDelivery##</span>but the bill of lading has not arrived and we, ##HereByName##,                          hereby request you to deliver the said cargo                          to<span>##CargoTo##</span>at<span>##PortofDischarge##</span>without production of the original                          bill of lading.</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:10px">
                  <p class="sub-heading" style="font-size:14px">In consideration of your complying with our above                          request, we hereby agree as follows: -</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:10px">
                  <p class="sub-heading" style="font-size:14px">1. To indemnify you, your servants and agents and to                          hold all of you harmless in respect of any liability, loss, damage or expense of whatsoever                          nature which you may sustain by reason of delivering the cargo in accordance with our request                      </p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:10px">
                  <p class="sub-heading" style="font-size:14px">2. In the event of any proceedings being commenced                          against you or any of your servants or agents in connection with the delivery of the cargo as                          aforesaid, to provide you or them on demand with sufficient funds to defend the same.</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:10px">
                  <p class="sub-heading" style="font-size:14px">3. If, in connection with the delivery of the cargo as                          aforesaid, the ship, or any other ship or property in the same or associated ownership,                          management or control, should be arrested or detained or should the arrest or detention thereof                          be threatened, or should there be any interference in the use or trading of the vessel (whether                          by virtue of a caveat being entered on the ship’s registry or otherwise howsoever), to provide                          on demand such bail or other security as may be required to prevent such arrest or detention or                          to secure the release of such ship or property or to remove such interference and to indemnify                          you in respect of any liability, loss, damage or expense caused by such arrest or detention or                          threatened arrest or detention or such interference, whether or not such arrest or detention or                          threatened arrest or detention or such interference may be justified.</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:10px">
                  <p class="sub-heading" style="font-size:14px">1. To indemnify you, your servants and agents and to                          hold all of you harmless in respect of any liability, loss, damage or expense of whatsoever                          nature which you may sustain by reason of delivering the cargo in accordance with our request                      </p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:10px">
                  <p class="sub-heading" style="font-size:14px">4. If the place at which we have asked you to make                          delivery is a bulk liquid or gas terminal or facility, or another ship, lighter or barge, then                          delivery to such terminal, facility, ship, lighter or barge shall be deemed to be delivery to                          the party to whom we have requested you to make such delivery.</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:10px">
                  <p class="sub-heading" style="font-size:14px">5. As soon as all original bills of lading for the                          above cargo shall have come into our possession, to deliver the same to you, or otherwise to                          cause all original bills of lading to be delivered to you, whereupon our liability hereunder                          shall cease.</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:10px">
                  <p class="sub-heading" style="font-size:14px">6. The liability of each and every person under this                          indemnity shall be joint and several and shall not be conditional upon your proceeding first                          against any person, whether or not such person is party to or liable under this indemnity.</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:10px">
                  <p class="sub-heading" style="font-size:14px">7. This indemnity shall be governed by and construed                          in accordance with English law and each and every person liable under this indemnity shall at                          your request submit to the jurisdiction of the High Court of Justice of England.</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:20px">
                  <p class="sub-heading" style="font-size:14px">Yours faithfully,</p>
                  <p class="sub-heading" style="font-size:14px">For and on behalf of</p>
                  <p class="sub-heading" style="font-size:14px"><span>##Requestor##</span></p>
                  <p class="sub-heading" style="font-size:14px">The Requestor</p>
               </div>
            </div>
            <div class="row">
               <div class="col-12" style="margin-top:50px">
                  <p class="sub-heading">.......................................</p>
                  <p class="sub-heading">##Signature##</p>
				 
               </div>
			   
            </div>
			<div class="row">
            <div class="col-12" style="margin-top:70px">
                 ##UserStampHTML##
            </div>
        </div>
         </div>
      </div>
   </body>
</html>'  WHERE EmailTemplateName = 'LOIOFDischargingCargoPortPdfTemplate' AND CompanyId = @CompanyId


END