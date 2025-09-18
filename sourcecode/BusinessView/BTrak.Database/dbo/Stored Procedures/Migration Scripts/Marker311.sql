CREATE PROCEDURE [dbo].[Marker311]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

  MERGE INTO [dbo].[CompanySettings] AS Target
    USING ( VALUES
       (NEWID(), @CompanyId, N'IncludeYTD', N'1', N'Include YTD', CAST(N'2021-03-10T11:37:09.943' AS DateTime), @UserId)
    )
    AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])
    ON Target.Id = Source.Id
    WHEN MATCHED THEN
    UPDATE SET CompanyId = Source.CompanyId,
               [Key] = source.[Key],
               [Value] = Source.[Value],
               [Description] = source.[Description],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]) 
    VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]);

	MERGE INTO [dbo].[HtmlTemplates] AS Target 
		USING ( VALUES 
		(NEWID(),'PayslipDetailsTemplateWithOutYTD',
		'<!DOCTYPE html>
			<html>
			<head>
				<link href="https://fonts.googleapis.com/css?family=PT Serif" rel="stylesheet">
			    <title>Template</title>
				<style>
			body {
			    font-family: "PT Serif";
			}
			</style>
			</head>
			
			<body style="color: #484646;font-size:12px">
			    <div id="html2Pdf">
					 <table style="margin-left: 5px;width:540px;">
					 <tbody>
					 <tr>
					 <td width="70%" height="100px">
			            <h6 style="font-weight: bold;font-size: 20px;margin-bottom: 5px;">##companyName</h6>
			            <div style="margin-top:0px; margin-bottom: 0; font-weight: bold;">Parent Head Office:</div>
						<div style="margin-top:0px; margin-bottom: 0;"> ##headOfficeAddress</div>
			            <div style="margin-top:0px; margin-bottom: 0; font-weight: bold;"> All branches: </div>
						<div style="margin-top:0px; margin-bottom: 0;"> ##companySiteAddress</div>
					</td>
					 <td width="30%" style="float:right;" height="100px">
					      <img width="150px" style="margin-top: 50px" src="###CompanyLogo##">
					</td>
					</tr>
					</tbody>
					</table>
			        <div>
			            <h6 style="font-size: 1rem;font-weight: bold;text-align: center; margin-bottom: 10px; line-height: 1.1; color: inherit;"> Payslip for the month of ##payrollMonth</h6>
						<div style="width:540px;border:1px solid #000;">
			            <table style="border-collapse: collapse;width:540px;">
						<tbody>
			                <tr>
			                    <td width="20%" style="padding-left:2px;">Name:</td>
			                    <td width="30%">##employeeName</td>
			                    <td width="20%" style="padding-left:2px;">Bank Name:</td>
			                    <td width="30%">##bankName</td>
			                </tr>
			                <tr>
			                    <td width="20%" style="padding-left:2px;">Date of Joining:</td>
			                    <td width="30%">##dateOfJoining</td>
			                    <td width="20%" style="padding-left:2px;">Bank Account No:</td>
			                    <td width="30%">##bankAccountNumber</td>
			                </tr>
			                <tr>
			                    <td width="20%" style="padding-left:2px;">Designation:</td>
			                    <td width="30%">##designation</td>
			                    <td width="20%" style="padding-left:2px;">PF No:</td>
			                    <td width="30%">##pfNumber</td>
			                </tr>
			                <tr>
			                    <td width="20%" style="padding-left:2px;">Department:</td>
			                    <td width="30%">##department</td>
			                    <td width="20%" style="padding-left:2px;">UAN:</td>
			                    <td width="30%">##uan</td>
			                </tr>
			                <tr>
			                    <td width="20%" style="padding-left:2px;">Location:</td>
			                    <td width="30%">##location</td>
			                    <td width="20%" style="padding-left:2px;">ESI No:</td>
			                    <td width="30%">##esiNumber</td>
			                </tr>
			                <tr>				
			                    <td width="20%" style="padding-left:2px;">Effective Work Days:</td>
			                    <td width="30%">##effectiveWorkingDays</td>
			                    <td width="20%" style="padding-left:2px;">PAN No:</td>
			                    <td width="30%">##panNumber</td>
			                </tr>
			                <tr>
			                    <td width="20%" style="padding-left:2px;">Days In Month:</td>
			                    <td width="30%">##daysInMonth</td>
			                    <td width="20%" style="padding-left:2px;">LOP:</td>
			                    <td width="30%">##lop</td>
			                </tr>
							</tbody>
			            </table>
			            <table style="border-collapse: collapse; width:540px;border-top: 1px solid #000;">
			                <tr>
			                    <th width="30%" height="20px" style="text-align:left;padding-left:2px;">Earnings</th>
			                    <th width="10%" height="20px" style="text-align:left"></th>
			                    <th width="10%" height="20px" style="text-align:left;border-right: 1px solid #000;">##payrollMonth</th>
			                    <th width="30%" height="20px" style="text-align:left;padding-left:2px;">Deductions</th>
								 <th width="10%" height="20px" style="text-align:left"></th>
			                    <th width="10%" height="20px" style="text-align:left">##payrollMonth</th>
			                </tr> 
			            </table>
						<table style="width: 540px;border-collapse: collapse;border-top: 1px solid #000;">
						<tbody>
						##payrollComponent
						</tbody>
						</table>
						<table style="width: 540px;border-collapse: collapse;border-top: 1px solid #000;">
						<tbody>
						  <tr>
			                 <td width="30%" height="20px" style="font-weight: bold;padding-left:2px;">Total Earnings:##currencyFormat.</td>
			                 <td width="10%" height="20px"></td>
			                 <td width="10%" height="20px" style="border-right: 1px solid #000;">##totalEarnings</td>
			                 <td width="30%" height="20px" style="font-weight: bold; padding-left:2px;">Total Deductions:##currencyFormat.</td>
							 <td width="10%" height="20px"></td>
			                 <td width="10%" height="20px">##totalDeduction</td>
			              </tr>
						</tbody>
						</table>
						<table style="width: 540px;border-collapse: collapse;border-top: 1px solid #000;">
						<tbody>
						 <tr>
						 <td style="padding-left:2px;" width="62%" height="20px">Net Pay for the month ( Total Earnings - Total Deductions):</td>
						 <td style="padding-left:2px;" width="38%" height="20px">##totalActualAmount</td></tr>
						  <tr>
						 <td style="padding-left:2px;" width="62%" height="20px">Net Pay for year ( Total Earnings - Total Deductions):</td>
						 <td style="padding-left:2px;" width="38%" height="20px">##netPayAmount</td></tr>
						</tbody>
						</table>
						<table style="width: 540px;border-collapse: collapse;border-top: 1px solid #000;">
						<tbody>
						  <tr>
						  <td style="padding-left:2px;" width="20%" height="20px">Net Pay for the month</td>
						   <td style="padding-left:2px;" width="50%" height="20px">(##actualNetPayAmountInWords)</td>
						   </tr>
						</tbody>
						</table>
						 </div>
			            <p style="text-align: center;margin-top:0px;font-size:10px">This is a system generated payslip and does not require signature.</p>
			        </div>
			    </div>
			</body>
			</html>'
		,'2020-03-13','1A72BC63-8CC4-4C10-ACBA-E1300B19F7BA',@CompanyId
		)
		)
	AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
	ON Target.[HtmlTemplate] = Source.[HtmlTemplate]  AND Target.[CompanyId] = Source.[CompanyId]  
	--WHEN MATCHED THEN 
	--UPDATE SET [TemplateName] = Source.[TemplateName],
	--           [HtmlTemplate] = Source.[HtmlTemplate],
	--           [CreatedDateTime] = Source.[CreatedDateTime],
	--           [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
	VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]);

	MERGE INTO [dbo].[HtmlTemplates] AS Target 
		USING ( VALUES 
		
		(NEWID(),'PayslipComponentTemplateWithOutYTD',
		'<tr>          
		<td width="30%" style="padding-left:2px;">##componentName##</td>          
		<td width="10%"></td>
		<td width="10%" style="border-right: 1px solid #000;">##actual##</td>     
		<td width="30%"></td>
		<td width="10%"></td>
		<td width="10%"></td>
		</tr>'
		,'2020-03-13','1A72BC63-8CC4-4C10-ACBA-E1300B19F7BA',@CompanyId
		)
		)
	AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
	ON Target.[TemplateName] = Source.[TemplateName] AND Target.[CompanyId] = Source.[CompanyId]  
	--WHEN MATCHED THEN 
	--UPDATE SET [TemplateName] = Source.[TemplateName],
	--           [HtmlTemplate] = Source.[HtmlTemplate],
	--           [CreatedDateTime] = Source.[CreatedDateTime],
	--           [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
	VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) ;

	MERGE INTO [dbo].[HtmlTemplates] AS Target 
		USING ( VALUES 
		
		(NEWID(),'PayslipDeductionsComponentTemplateWithOutYTD',
		'<tr> <td width="30%"></td>
			<td width="10%"></td>
			<td width="10%"></td>
			<td width="30%" style="border-left: 1px solid #000;padding-left:2px">##componentName##</td>
			<td width="10%"></td>
			<td width="10%">##actual##</td></tr>'
		,'2020-03-13','1A72BC63-8CC4-4C10-ACBA-E1300B19F7BA',@CompanyId
		)
		)
	AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
	ON Target.[TemplateName] = Source.[TemplateName] AND Target.[CompanyId] = Source.[CompanyId]    
	--WHEN MATCHED THEN 
	--UPDATE SET [TemplateName] = Source.[TemplateName],
	--           [HtmlTemplate] = Source.[HtmlTemplate],
	--           [CreatedDateTime] = Source.[CreatedDateTime],
	--           [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
	VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) ;
END
GO