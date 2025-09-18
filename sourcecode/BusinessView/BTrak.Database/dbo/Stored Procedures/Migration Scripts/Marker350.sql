CREATE PROCEDURE [dbo].[Marker350]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
        MERGE INTO [dbo].[HtmlTemplates] AS Target 
        USING ( VALUES 

		(NEWID(), 'CreditNotePDFTemplate',
			'<!DOCTYPE html>
	<html>
	<style>
		.div {
			box-sizing: border-box
		}

		.p-1 {
			padding: 1rem !important
		}

		h6 {
			font-size: 1rem;
			margin-bottom: .5rem;
			font-weight: 400;
			line-height: 1.1;
			color: inherit;
			margin-top: 0
		}

		.fxLayout-row {
			flex-flow: row wrap;
			box-sizing: border-box;
			display: flex
		}

		.fxFlex48 {
			flex: 1 1 100%;
			box-sizing: border-box;
			max-width: 48%
		}

		.fxFlex {
			flex: 1 1 0%;
			box-sizing: border-box
		}

		.fxFlex49-column {
			flex: 1 1 100%;
			box-sizing: border-box;
			flex-direction: column;
			display: flex;
			max-width: 49%
		}

		.fxFlex50-row-start {
			flex: 1 1 50%;
			box-sizing: border-box;
			place-content: center flex-start;
			align-items: center;
			flex-direction: row;
			display: flex;
			max-width: 50%
		}

		.fxFlex50-column-start {
			flex: 1 1 50%;
			box-sizing: border-box;
			place-content: center flex-start;
			align-items: center;
			flex-direction: column;
			display: block;
			max-width: 50%
		}

		.fxFlex50-column-end {
			flex: 1 1 50%;
			box-sizing: border-box;
			place-content: flex-start flex-end;
			align-items: center;
			flex-direction: column;
			display: block;
			max-width: 50%
		}

		.fxFlex100 {
			flex: 1 1 100%;
			box-sizing: border-box;
			max-width: 100%
		}

		.fxFlex100-end {
			flex: 1 1 100%;
			box-sizing: border-box;
			place-content: flex-start flex-end;
			align-items: flex-start;
			flex-direction: row;
			display: flex;
			max-width: 100%
		}

		.fxLayout-end {
			place-content: center flex-end;
			align-items: center;
			flex-direction: row;
			box-sizing: border-box;
			display: flex
		}

		.word-break {
			word-break: break-word !important
		}

		.d-block {
			display: bloack !important
		}

		.mb-1 {
			margin-bottom: 1rem !important
		}

		.mt-02 {
			margin-top: .3rem !important
		}

		.mt-1 {
			margin-top: 1rem !important
		}

		.mt-1-05 {
			margin-top: 1.5rem
		}

		.ml-1 {
			margin-left: 1rem !important
		}

		.mt-05 {
			margin-top: .5rem !important
		}

		.mr-05 {
			margin-right: .5rem !important
		}

		.invoice-amount-price {
			font-size: 23px;
			font-weight: 700;
			position: relative;
			top: 1px
		}

		.overflow-visible {
			overflow: visible
		}

		.table-responsive {
			display: block;
			width: 100%;
			overflow-x: auto;
			-webkit-overflow-scrolling: touch
		}

		.mb-0 {
			margin-bottom: 0 !important
		}

		.table {
			width: 100%;
			margin-bottom: 1rem;
			color: #212529
		}

		table {
			border-collapse: collapse
		}

		.invoice-container td:first-child,
		.invoice-container th:first-child {
			text-align: inherit;
			padding-left: 0;
			width: 40%
		}

		.table thead th {
			vertical-align: bottom;
			border-bottom: 2px solid #dee2e6
		}

		.invoice-container td,
		.invoice-container th {
			padding-right: 0;
			text-align: right;
			width: 13%
		}

		.invoice-entry-from-container {
			margin-right: 2cm;
			margin-left: 2cm;
			margin-top: 2.5cm
		}

		.invoice-entry-from-container-margin-left {
			margin-right: 2cm
		}

		.table td,
		.table th {
			padding: .75rem;
			vertical-align: top;
			border-top: 1px solid #dee2e6
		}

		td {
			page-break-before: always
		}

		th {
			page-break-before: always
		}

		@page {
			margin-top: 10px;
			margin-bottom: 10px
		}
	</style>

	<body>
		<div style="margin-top:2cm" class="invoice-preview-height">
			<style>
				.d {
					border-bottom: 1px solid #ddd
				}

				.page-font {
					font-size: 10px
				}

				.a {
					border: 1px solid #ddd;
					text-align: left;
					width: 95%;
					border-collapse: collapse;
					font-size: 10px
				}

				.b {
					text-align: left;
					padding: 6px;
					width: 20px;
					border-collapse: collapse;
					word-break: break-word;
					font-size: 10px
				}

				table {
					page-break-inside: auto
				}

				th {
					font-weight: 400
				}

				.c {
					border-top: 1px solid #ddd
				}
			
				.e{
					border-bottom: double;
				}
				
				.f{
					text-align: left;
					padding: 6px;
					padding-right: 0px;
					width: 20px;
					border-collapse: collapse;
					word-break: break-word;
					font-size: 10px
				}
			
				.align-right{
					text-align: right;
				}
			</style>
			<div class="invoice-container">
				<div style="display:flex">
					<div class="fxLayout-row">
						<div class="fxFlex50-start d-block word-break page-font" style="margin-left:0.5cm">PHOTON ONE SA<br>Pré de la Joux-Dessous
							1<br>1635 La Tour-de-Trême<br>No TVA : CHE-303.848.436 TVA<br>Email :
							mfs.merchant.finance@gmail.com<br>Tél. : 079-221.71.42</div>
					</div>
					<div class="d-block word-break page-font" style="margin-left:4.7cm;margin-top:0.3cm;height:2cm;width:4.5cm">##Address##</div>
				</div>
			</div>
		</div>
		<div>
			<div class="fxLayout-row">
				<div class="fxFlex50-column-start mb-1">
					<div class="fxFlex100"></div>
				</div>
				<div class="fxFlex50-column-end">
					<div class="fxFlex100-end mt-02"><span class="page-font" style="text-align:right;margin-right:4cm">La
							Tour-de-Trême, le : ##GridInvoiceDate##</span></div>
				</div>
			</div>
		</div>
<div>
					<center class="page-font"><b>NOTE DE CREDIT</b></center>
</div>
<div>
				<center class="page-font"><b>##TITLE##</b></center>
</div>
		<center>
			<table class="a" style="margin-bottom:10px;margin-right:0.5cm;margin-left:0.25cm;border:none">
				<tr>
					<th class="d b">
						<center style="padding-top:23px">Pièce</center>
					</th>
					<th class="d">
						<center style="padding-top:23px">Du</center>
					</th>
					<th class="d">
						<center style="padding-top:23px">Au</center>
					</th>
					<th class="d">
						<center style="padding-top:23px">Jours</center>
					</th>
					<th class="d">
						<center style="padding-top:23px">m2</center>
					</th>
					<th class="d">
						<center style="padding-top:23px">CHF/m2</center>
					</th>
					<th class="d">
						<center style="padding-top:23px">p.a.</center>
					</th>
					<th class="d">
						<center style="padding-top:23px">Prorata</center>
					</th>
					<th class="d">
						<center style="padding-top:2px"><b>CHF</b></center>
					</th>
				</tr>
				<tr>
					<td class="b">servitude</td>
					<td class="b">
						<center>loyer toiture</center>
					</td>
					<td class="b">
						<center>##ROOFADDRESS##</center>
					</td>
					<td class="b">
					</td>
					<td class="b">
					</td>
					<td class="b">
					</td>
					<td class="b">
					</td>
					<td class="b">
					</td>
					<td class="b">
					</td>
				</tr>
				<tr>
					<td class="b">##DATE##</td>
					<td class="b">
						<center>##STARTDATE##</center>
					</td>
					<td class="b">
						<center>##ENDDATE##</center>
					</td>
					<td class="b">
						<center>##JOURS##</center>
					</td>
					<td class="b">
						<center>##M2##</center>
					</td>
					<td class="b">
						<center>##CHF/M2##</center>
					</td>
					<td class="b">
						<center>##PERANNUM##</center>
					</td>
					<td class="b">
						<center>##PRORATA##</center>
					</td>
					<td class="b">
						<center><b>##TOTALCHF##<b></center>
					</td>
				</tr>
				<tr>
					<td class="b">Parcelle No    ##PARCELLENO##</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center>##TVANAME##</center>
					</td>
					<td class="b">
					<center>##TVA##</center>
					</td>
				</tr>
				<tr>
					<td class="b">Arrondi</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="e align-right">
					<center>##Arrondi##</center>
					</td>
				</tr>
				<tr>
					<td class="b">Montant à payer</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center></center>
					</td>
					<td class="b">
						<center>CHF</center>
					</td>
					<td class="c e align-right">
						<center><b>##TotalValue##</b></center>
					</td>
				</tr>
			</table>
		</center>
		<p class="page-font" style="margin-left:0.5cm; margin-top:1cm">Merci de votre collaboration</p>
		<p class="page-font" style="margin-left:0.5cm">Photon One SA</p>
	</body>

	</html>'
			,GETDATE(),@UserId, @CompanyId),

		(NEWID(), 'CreditNoteEmailTemplate',
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
                                                                           <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                              <table class="contents" style="border-spacing:0; width:100%">
                                                                                 <tr>
                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                       <a href="#" target="_blank"><img src=##CompanyLogo## alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a>
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
                                       Dear,
                                       </p>
									     <div style="width: 100%;">
									   <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Credit note has been generated successfully, Please view the details in the attachment
                                                </p>
									   </div>
                                      
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                              <br />                                                              Best Regards, <br />                                                              ##footerName##                                                          </p>
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
			,GETDATE(),@UserId, @CompanyId)

		)
        AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        ON Target.[TemplateName] = Source.[TemplateName]  AND Target.[CompanyId] = Source.[CompanyId]
        WHEN MATCHED THEN 
        UPDATE SET [TemplateName] = Source.[TemplateName],
                   [HtmlTemplate] = Source.[HtmlTemplate],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId],
                   [CompanyId] = Source.[CompanyId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]);
		IF(@CompanyId='C15478CA-7201-477B-908E-F1E03792E07C')
		BEGIN
DECLARE @CurrentDate DATETIME = GETDATE();
	MERGE INTO [dbo].[MasterAccounts] AS Target 
    USING ( VALUES
	(NEWID(),'BAS (bank) current account',1,1,'Assets','Actif','Liquid Assets','Actifs circulants','Cash and Equivalents','Liquidités et titres',1020,1020,'BAS 371.819.100-02 Compte courant',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Credit Suisse (bank) capital account',1,1,'Assets','Actif','Liquid Assets','Actifs circulants','Cash and Equivalents','Liquidités et titres',1021,1021,'CS 2694876-11-9 Compte de consignation de capital',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Transitory Account',1,1,'Assets','Actif','Liquid Assets','Actifs circulants','Cash and Equivalents','Liquidités et titres',1090,1090,'Compte d''attente',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Transitory Account Salaries',1,1,'Assets','Actif','Liquid Assets','Actifs circulants','Cash and Equivalents','Liquidités et titres',1091,1091,'Compte de passage salaires',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Third Party Receivables',1,1,'Assets','Actif','Liquid Assets','Actifs circulants','Third parties Receivables','Créances envers des tiers',1100,1100,'Créances envers des tiers',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Provision for Losses on Receivables',1,1,'Assets','Actif','Liquid Assets','Actifs circulants','Third parties Receivables','Créances envers des tiers',1109,1109,'Provision pour pertes sur créances',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Other Third Parties Short Term Receivables',1,1,'Assets','Actif','Liquid Assets','Actifs circulants','Other Short Term Receivables','Autres créances à court terme',1140,1140,'Autres créances à court terme envers des tiers',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Other Shareholder Short Term Receivables',1,1,'Assets','Actif','Liquid Assets','Actifs circulants','Other Short Term Receivables','Autres créances à court terme',1160,1160,'Autres créances à court terme envers l''actionnaire',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'VAT to be recovered on purchases',1,1,'Assets','Actif','Liquid Assets','Actifs circulants','Other Short Term Receivables','Autres créances à court terme',1170,1170,'TVA à récupérer sur achats de matières et services',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'VAT to be recovered on investments (fixed assets)',1,1,'Assets','Actif','Liquid Assets','Actifs circulants','Other Short Term Receivables','Autres créances à court terme',1171,1171,'TVA à récupérer sur investissements et autres charges',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Other Recoverables',1,1,'Assets','Actif','Liquid Assets','Actifs circulants','Other Short Term Receivables','Autres créances à court terme',1172,1172,'REDIP TVA',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'WHT to be recovered',1,1,'Assets','Actif','Liquid Assets','Actifs circulants','Other Short Term Receivables','Autres créances à court terme',1176,1176,'Impôt anticipé à récupérer',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Deferred Assets',1,1,'Assets','Actif','Liquid Assets','Actifs circulants','Deferred Assets','Actifs de régularisation',1300,1300,'Actifs de régularisation',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Long Term Third Parties Receivables',1,1,'Assets','Actif','Fixed Assets','Actifs immobilisés','Financial Fixed Assets','Immobilisations financières',1440,1440,'Créances à long terme envers des tiers',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Long Term Shareholder Receivables',1,1,'Assets','Actif','Fixed Assets','Actifs immobilisés','Financial Fixed Assets','Immobilisations financières',1460,1460,'Créances à long terme envers l''actionnaire',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'DUC PV Plant',1,1,'Assets','Actif','Fixed Assets','Actifs immobilisés','Furniture and Equipment','Mobilier et installations',1510,1510,'Centrale photovoltaïque (Duc/FR)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'DUC PV Plant Depreciation',1,1,'Assets','Actif','Fixed Assets','Actifs immobilisés','Furniture and Equipment','Mobilier et installations',1511,1511,'Fonds d''amortissement centrale photovoltaïque (Duc/FR)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'COT PV Plant',1,1,'Assets','Actif','Fixed Assets','Actifs immobilisés','Furniture and Equipment','Mobilier et installations',1512,1512,'Centrale photovoltaïque (Cottet et Bochud/FR)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'COT PV Plant Depreciation',1,1,'Assets','Actif','Fixed Assets','Actifs immobilisés','Furniture and Equipment','Mobilier et installations',1513,1513,'Fonds d''amortissement centrale photovoltaïque (Cottet et Bochud/FR)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'GEN PV Plant',1,1,'Assets','Actif','Fixed Assets','Actifs immobilisés','Furniture and Equipment','Mobilier et installations',1514,1514,'Centrale photovoltaïque (Genoud/FR)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'GEN PV Plant Depreciation',1,1,'Assets','Actif','Fixed Assets','Actifs immobilisés','Furniture and Equipment','Mobilier et installations',1515,1515,'Fonds d''amortissement centrale photovoltaïque (Genoud/FR)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'GUE PV Plant',1,1,'Assets','Actif','Fixed Assets','Actifs immobilisés','Furniture and Equipment','Mobilier et installations',1516,1516,'Centrale photovoltaïque (Guerry/VD)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'GUE PV Plant Depreciation',1,1,'Assets','Actif','Fixed Assets','Actifs immobilisés','Furniture and Equipment','Mobilier et installations',1517,1517,'Fonds d''amortissement centrale photovoltaïque (Guerry/VD)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'SCH PV Plant',1,1,'Assets','Actif','Fixed Assets','Actifs immobilisés','Furniture and Equipment','Mobilier et installations',1518,1518,'Centrale photovoltaïque (Schertenleib/VD)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'SCH PV Plant Depreciation',1,1,'Assets','Actif','Fixed Assets','Actifs immobilisés','Furniture and Equipment','Mobilier et installations',1519,1519,'Fonds d''amortissement centrale photovoltaïque (Schertenleib/VD)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Real Estate',1,1,'Assets','Actif','Fixed Assets','Actifs immobilisés','Real Estate Assets','Immobilisations corporelles immeubles',1600,1600,'Immeubles',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Liabilities on Purchases (Cost of Sales)',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Short term Liabilities on Purchases (Costs of Sales)','Dettes à court terme c/achats et prestations de services',2000,2000,'Dettes c/achats de matières et de marchandises',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'BAS loan subsidy DUC',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Short term Liabilities bearing interest ','Dettes financières à court terme portant intérêts',2100,2100,'BAS, prêt pont RU 371.819.300-05 (Duc)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'BAS loan subsidy COT',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Short term Liabilities bearing interest ','Dettes financières à court terme portant intérêts',2101,2101,'BAS, prêt pont RU 371.819.310-02 (Cottet et Bochud)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'BAS loan VAT COT',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Short term Liabilities bearing interest ','Dettes financières à court terme portant intérêts',2101.1,2101.1,'BAS, prêt pont TVA 371.819.309-09 (Cottet et Bochud)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'BAS loan subsidy GEN',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Short term Liabilities bearing interest ','Dettes financières à court terme portant intérêts',2102,2102,'BAS, prêt pont RU 371.819.307-02 (Genoud)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'BAS loan VAT GEN',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Short term Liabilities bearing interest ','Dettes financières à court terme portant intérêts',2102.1,2102.1,'BAS, prêt pont TVA 371.819.306-04 (Genoud)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'BAS loan subsidy GUE',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Short term Liabilities bearing interest ','Dettes financières à court terme portant intérêts',2103,2103,'BAS, prêt pont RU 371.819.304-08 (Guerry)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'BAS loan VAT GUE',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Short term Liabilities bearing interest ','Dettes financières à court terme portant intérêts',2103.1,2103.1,'BAS, prêt pont TVA 371.819.303-00 (Guerry)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'BAS loan subsidy SCH',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Short term Liabilities bearing interest ','Dettes financières à court terme portant intérêts',2104,2104,'BAS, prêt pont RU 371.819.313-07 (Schertenleib)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'BAS loan VAT SCH',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Short term Liabilities bearing interest ','Dettes financières à court terme portant intérêts',2104.1,2104.1,'BAS, prêt pont TVA 371.819.312-09 (Schertenleib)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Other Third Parties Short Term Liabilities ',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Short term Liabilities bearing interest ','Dettes financières à court terme portant intérêts',2140,2140,'Autres dettes financières à court terme envers des tiers',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Other Shareholder Short Term Liabilities ',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Short term Liabilities bearing interest ','Dettes financières à court terme portant intérêts',2160,2160,'Dettes financières à court terme envers l''actionnaire',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'VAT payable',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Other Short Term Liabilities','Autres dettes à court terme',2200,2200,'TVA à payer',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'VAT break-down Federal Tax Administration',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Other Short Term Liabilities','Autres dettes à court terme',2205,2205,'AFC - décompte TVA',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Dividends',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Other Short Term Liabilities','Autres dettes à court terme',2230,2230,'Dividendes',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'WHT current account',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Other Short Term Liabilities','Autres dettes à court terme',2280,2280,'C/c impôt à la source',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Deferred Liabilities',2,2,'Liabilities','Passif','Short term Liabilities','Capitaux étrangers à court terme','Deferred Liabilities','Passifs de régularisation',2300,2300,'Passifs de régularisation',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'BAS fix term loan DUC',2,2,'Liabilities','Passif','Long term Liabilities','Capitaux étrangers à long terme','Long term Liabilities bearing interest','Dettes financières à long terme portant intérêts',2440,2440,'BAS, prêt taux fixe 371.819.301-03 (Duc)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'BAS fix term loan COT',2,2,'Liabilities','Passif','Long term Liabilities','Capitaux étrangers à long terme','Long term Liabilities bearing interest','Dettes financières à long terme portant intérêts',2441,2441,'BAS, prêt taux fixe 371.819.308-00 (Cottet et Bochud)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'BAS fix term loan GEN',2,2,'Liabilities','Passif','Long term Liabilities','Capitaux étrangers à long terme','Long term Liabilities bearing interest','Dettes financières à long terme portant intérêts',2442,2442,'BAS, prêt taux fixe 371.819.305-06 (Genoud)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'BAS fix term loan GUE',2,2,'Liabilities','Passif','Long term Liabilities','Capitaux étrangers à long terme','Long term Liabilities bearing interest','Dettes financières à long terme portant intérêts',2443,2443,'BAS, prêt taux fixe 371.819.302-01 (Guerry)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'BAS fix term loan SCH',2,2,'Liabilities','Passif','Long term Liabilities','Capitaux étrangers à long terme','Long term Liabilities bearing interest','Dettes financières à long terme portant intérêts',2444,2444,'BAS, prêt taux fixe 371.819.311-00 (Schertenleib)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Long Term Third Parties Borrowings',2,2,'Liabilities','Passif','Long term Liabilities','Capitaux étrangers à long terme','Other Long Term Liabilities','Autres dettes à long terme',2500,2500,'Emprunt à long terme à des tiers',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Subordinated Shareholder Borrowing',2,2,'Liabilities','Passif','Long term Liabilities','Capitaux étrangers à long terme','Other Long Term Liabilities','Autres dettes à long terme',2560,2560,'Emprunt subordonné Merchant Finance Solutions SA (31.12.2035)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Shareholder Borrowing',2,2,'Liabilities','Passif','Long term Liabilities','Capitaux étrangers à long terme','Other Long Term Liabilities','Autres dettes à long terme',2561,2561,'Emprunt Merchant Finance Solutions SA',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Share Capital',2,2,'Liabilities','Passif','Equity (own capital)','Capitaux propres','Share Capital','Capital-actions',2800,2800,'Capital-actions',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'General Reserve',2,2,'Liabilities','Passif','Equity (own capital)','Capitaux propres','Legal Reserves','Réserves légales issues du bénéfice',2900,2900,'Réserve générale',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Retained Earnings/Losses',2,2,'Liabilities','Passif','Equity (own capital)','Capitaux propres','Profit and Loss ','Bénéfice et perte résultant du bilan',2990,2990,'Bénéfice reporté/perte reportée',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Current Year Earnings/Losses',2,2,'Liabilities','Passif','Equity (own capital)','Capitaux propres','Profit and Loss ','Bénéfice et perte résultant du bilan',2991,2991,'Bénéfice de l''exercice/perte de l''exercice',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Electricity Sales (FR)',4,4,'Profits (Revenues)','Produits','Turnover','Produits','Sales','Ventes',3200,3200,'Ventes d''énergie (FR)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Electricity Sales (VD)',4,4,'Profits (Revenues)','Produits','Turnover','Produits','Sales','Ventes',3210,3210,'Ventes d''énergie (VD)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Expenses Groupe E (FR)',3,3,'Profits (Revenues)','Charges','Purchases (Cost of Sales)','Charges de marchandises et de services','Purchases (Cost of Sales)','Charges de marchandises et de services',4200,4200,'Frais Groupe E (FR)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Expenses Romande E (VD)',3,3,'Profits (Revenues)','Charges','Purchases (Cost of Sales)','Charges de marchandises et de services','Purchases (Cost of Sales)','Charges de marchandises et de services',4201,4201,'Frais Groupe E (VD)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Maintenance',3,3,'Profits (Revenues)','Charges','Purchases (Cost of Sales)','Charges de marchandises et de services','Purchases (Cost of Sales)','Charges de marchandises et de services',4210,4210,'Entretien',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Duties and Levies',3,3,'Profits (Revenues)','Charges','Purchases (Cost of Sales)','Charges de marchandises et de services','Purchases (Cost of Sales)','Charges de marchandises et de services',4220,4220,'Droits, taxes, impôts fonciers',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Insurance Premiums (FR)',3,3,'Profits (Revenues)','Charges','Purchases (Cost of Sales)','Charges de marchandises et de services','Purchases (Cost of Sales)','Charges de marchandises et de services',4230,4230,'Primes d''assurance (FR)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Insurance Premiums (VD)',3,3,'Profits (Revenues)','Charges','Purchases (Cost of Sales)','Charges de marchandises et de services','Purchases (Cost of Sales)','Charges de marchandises et de services',4231,4231,'Primes d''assurance (VD)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Sub-contractors',3,3,'Profits (Revenues)','Charges','Cost of Sales (subcontractors)','Charges pour prestations de tiers','Cost of Sales (subcontractors)','Charges pour prestations de services de tiers',4400,4400,'Sous-traitants',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Roof Rent (FR)',3,3,'Losses (Expenses)','Autres charges d''exploitation','General Expenses','Autres charges d''exploitation','Office expenses and maintenance','Frais des locaux et d''entretien',6000,6000,'Loyer (FR)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Roof Rent (VD)',3,3,'Losses (Expenses)','Autres charges d''exploitation','General Expenses','Autres charges d''exploitation','Office expenses and maintenance','Frais des locaux et d''entretien',6001,6001,'Loyer (VD)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Commercial Insurances Premiums',3,3,'Losses (Expenses)','Autres charges d''exploitation','General Expenses','Autres charges d''exploitation','Insurances Expenses','Assurances commerciales',6300,6300,'Assurances commerciales',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Administrative Expenses',3,3,'Losses (Expenses)','Autres charges d''exploitation','General Expenses','Autres charges d''exploitation','Administrative Expenses','Charges d''administration',6500,6500,'Gestion administrative',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Phone Expenses',3,3,'Losses (Expenses)','Autres charges d''exploitation','General Expenses','Autres charges d''exploitation','Administrative Expenses','Charges d''administration',6510,6510,'Téléphone',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Contributions',3,3,'Losses (Expenses)','Autres charges d''exploitation','General Expenses','Autres charges d''exploitation','Administrative Expenses','Charges d''administration',6520,6520,'Cotisations',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Accounting Expenses',3,3,'Losses (Expenses)','Autres charges d''exploitation','General Expenses','Autres charges d''exploitation','Administrative Expenses','Charges d''administration',6530,6530,'Honoraires pour fiduciaire',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Legal Expenses',3,3,'Losses (Expenses)','Autres charges d''exploitation','General Expenses','Autres charges d''exploitation','Administrative Expenses','Charges d''administration',6532,6532,'Honoraires pour conseil juridique',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Other General Expenses',3,3,'Losses (Expenses)','Autres charges d''exploitation','General Expenses','Autres charges d''exploitation','Administrative Expenses','Charges d''administration',6700,6700,'Autres charges d''exploitation',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Financial Expenses',3,3,'Losses (Expenses)','Autres charges d''exploitation','Financial Result','Résultat financier','Financial Expenses','Charges financières',6800,6800,'Charges financières',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Financial Expenses on Shareholder''s Account',3,3,'Losses (Expenses)','Autres charges d''exploitation','Financial Result','Résultat financier','Financial Expenses','Charges financières',6820,6820,'Charges financières s/comptes courants associés',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Bank charges',3,3,'Losses (Expenses)','Autres charges d''exploitation','Financial Result','Résultat financier','Financial Expenses','Charges financières',6840,6840,'Frais de banque',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Financial Revenues  ',4,4,'Losses (Expenses)','Autres charges d''exploitation','Financial Result','Résultat financier','Financial Revenues','Produits financiers',6850,6850,'Produits financiers',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Financial Revenues on Shareholder''s Account',4,4,'Losses (Expenses)','Autres charges d''exploitation','Financial Result','Résultat financier','Financial Revenues','Produits financiers',6880,6880,'Produits financiers s/comptes courants associés',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Depreciation on PV Plants (FR)',3,3,'Losses (Expenses)','Autres charges d''exploitation','Depreciation','Amortissements','Depreciation','Amortissements',6910,6910,'Amortissement s/centrales photovoltaïques (FR)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Depreciation on PV Plants (VD)',3,3,'Losses (Expenses)','Autres charges d''exploitation','Depreciation','Amortissements','Depreciation','Amortissements',6911,6911,'Amortissement s/centrales photovoltaïques (VD)',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Profits on Sales of Equipments',5,5,'Subactivities result','Résultat des activités annexes','Subactivities Result','Résultat des activités annexes','Subactivities Result','Résultat des activités annexes',7910,7910,'Bénéfices s/ventes d''équipements d''exploitation',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Profits on Sales of Real Estate',5,5,'Subactivities result','Résultat des activités annexes','Subactivities Result','Résultat des activités annexes','Subactivities Result','Résultat des activités annexes',7920,7920,'Bénéfices s/ventes d''immeubles',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Exceptional Revenues ',5,5,'Exceptional result','Résultat exceptionnel','Exceptional result','Résultat exceptionnel','Exceptional result','Résultat exceptionnel',8000,8000,'Produits exceptionnels',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Exceptional Expenses',5,5,'Exceptional result','Résultat exceptionnel','Exceptional result','Résultat exceptionnel','Exceptional result','Résultat exceptionnel',8010,8010,'Charges exceptionnelles',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Taxes current financial year',5,5,'Exceptional result','Résultat exceptionnel','Tax expenses','Charges d''impôts','Tax expenses','Charges d''impôts',8900,8900,'Impôts année en cours',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Taxes previous financial years',5,5,'Exceptional result','Résultat exceptionnel','Tax expenses','Charges d''impôts','Tax expenses','Charges d''impôts',8901,8901,'Impôts années antérieures',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Profits & Losses (P&L)',6,6,'Closing','Clôture','Profits & Losses (P&L)','Compte de résultat','Profits & Losses (P&L)','Compte de résultat',9000,9000,'Compte de résultat',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Opening Balance Sheet',6,6,'Closing','Clôture','Balance Sheet','Bilan','Balance Sheet','Bilan',9100,9100,'Bilan d''ouverture',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Closing Balance Sheet',6,6,'Closing','Clôture','Balance Sheet','Bilan','Balance Sheet','Bilan',9101,9101,'Bilan de clôture',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Consolidations of Debtors',6,6,'Closing','Clôture','Consolidations and adjustments','Ecriture de regroupements et de corrections','Consolidations','Ecritures de regroupements',9900,9900,'Ecritures de regroupements des débiteurs',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Consolidations of Creditors',6,6,'Closing','Clôture','Consolidations and adjustments','Ecriture de regroupements et de corrections','Consolidations','Ecritures de regroupements',9901,9901,'Ecritures de regroupements des créditeurs',@CurrentDate,@UserId,@CompanyId)
,(NEWID(),'Adjustments ',6,6,'Closing','Clôture','Consolidations and adjustments','Ecriture de regroupements et de corrections','Adjustments','Ecritures de corrections',9910,9910,'Ecritures de corrections',@CurrentDate,@UserId,@CompanyId)

    )
    AS Source ([Id], [Account], [ClassNo], [ClassNoF], [Class], [ClassF], [Group], [GroupF], [SubGroup], [SubGroupF], [AccountNo], [AccountNoF], [Compte], [CreatedDateTime], [CreatedByUserId], [CompanyId])
    ON Target.[Account] = Source.[Account] AND Target.[CompanyId] = Source.[CompanyId]  
    WHEN MATCHED THEN 
    UPDATE SET [Account] = Source.[Account],
               [ClassNo] = Source.[ClassNo],
               [ClassNoF] = Source.[ClassNoF],
               [Class] = Source.[Class],
               [ClassF] = Source.[ClassF],
               [Group] = Source.[Group],
               [GroupF] = Source.[GroupF],
               [SubGroup] = Source.[SubGroup],
               [SubGroupF] = Source.[SubGroupF],
               [AccountNo] = Source.[AccountNo],
               [AccountNoF] = Source.[AccountNoF],
               [Compte] = Source.[Compte],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], [Account], [ClassNo], [ClassNoF], [Class], [ClassF], [Group], [GroupF], [SubGroup], [SubGroupF], [AccountNo], [AccountNoF], [Compte], [CreatedDateTime], [CreatedByUserId], [CompanyId]) 
    VALUES ([Id], [Account], [ClassNo], [ClassNoF], [Class], [ClassF], [Group], [GroupF], [SubGroup], [SubGroupF], [AccountNo], [AccountNoF], [Compte], [CreatedDateTime], [CreatedByUserId], [CompanyId]);
	END
END