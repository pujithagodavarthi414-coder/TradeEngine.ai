CREATE PROCEDURE [dbo].[Marker403]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
 MERGE INTO [dbo].[ReferenceType] AS Target 
        USING (VALUES 
        		(N'B79A8DD7-A83C-45D3-9365-18503A07B3BF','Client Settings',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @UserId,NULL,NULL,NULL)
        ) 
        AS Source ([Id],[ReferenceTypeName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime])
        ON Target.[ReferenceTypeName] = Source.[ReferenceTypeName]
        WHEN MATCHED THEN 
        UPDATE SET [Id] = Source.[Id],
                   [ReferenceTypeName] = Source.[ReferenceTypeName],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId],
                   [UpdatedDateTime] = Source.[UpdatedDateTime],
                   [UpdatedByUserId] = Source.[UpdatedByUserId],
                   [InActiveDateTime] = Source.[InActiveDateTime]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id],[ReferenceTypeName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) VALUES ([Id],[ReferenceTypeName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

    DECLARE @Template TABLE
    	(
    		EmailTemplateName NVARCHAR(250)
    		,[EmailTemplate] NVARCHAR(MAX)
    		,[EmailSubject] NVARCHAR(2000)
            ,[EmailTemplateReferenceId] UNIQUEIDENTIFIER
    	)
    	INSERT INTO @Template(EmailTemplateName,EmailTemplate,EmailSubject,EmailTemplateReferenceId)
    	VALUES('ContractFinalPdfTemplate','<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MGV COMMODITY PTE LTD</title>
        <style>
            body{
                background-color: #F6F6F6; 
                margin: 0;
                padding: 0;
            }
            h1,h2,h3,h4,h5,h6{
                margin: 0;
                padding: 0;
            }
            p{
                margin: 0;
                padding: 0;
            }
            .container{
                width: 80%;
                margin-right: auto;
                margin-left: auto;
            }
            .row{
                display: flex;
                flex-wrap: wrap;
            }
            .col-6{
                width: 50%;
                flex: 0 0 auto;
            }
            .col-4{
                width: 25%;
                flex: 0 0 auto;
            }
            .col-8{
                width: 74%;
                flex: 0 0 auto;
            }
            .col-12{
                width: 100%;
                flex: 0 0 auto;
            }
            .body-section{
                padding: 16px;
                border: 1px solid gray;
            }
            .sub-heading{
                color: #262626;
                margin-bottom: 05px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="body-section">
                <div class="row">
                    <div class="col-12">
                        <div style="text-align: center;">##CompanyLogo##</div>
                        <p class="sub-heading" style="text-align: center; color: red; font-size: 40px;">##CompanyName##</p>
                        <p class="sub-heading" style="text-align: center;">##CompanyAddress##</p>
                        <p class="sub-heading" style="text-align: center;">##RegistrationNumberAndPhoneNumber##</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12" style="margin-top: 20px;">
                        <p class="sub-heading">##ContractType## CONTRACT NO: ##ContractNo##</p>
                        <p class="sub-heading">We hereby confirm the following trade done on ##ContractDate##</p>
                    </div>
                </div>    
                <div class="row">
                    <div class="col-12" style="margin-top: 20px;">
                        <table>
                            <tr>
                                <td style="padding-bottom: 15px;">Seller</td>
                                <td style="padding-bottom: 15px;">: ##SellerAddress##</td>
                            </tr>
                            <tr>
                                <td style="padding-bottom: 15px;">Buyer</td>
                                <td style="padding-bottom: 15px;">: ##BuyerAddress##<td>
                            </tr>
                            <tr>
                                <td style="padding-bottom: 15px;">Product</td>
                                <td style="padding-bottom: 15px;">: ##ProductName##<td>
                            </tr>
                            <tr>
                                <td style="padding-bottom: 15px;">Origin</td>
                                <td style="padding-bottom: 15px;">: ##Origin##<td>
                            </tr>
                            <tr>
                                <td style="padding-bottom: 15px;">Specification</td>
                                <td style="padding-bottom: 15px;">: ##Specifications##<td>
                            </tr>
                            <tr>
                            <td style="padding-bottom: 15px;">Quantity & Tolerance</td>
                                <td style="padding-bottom: 15px;">: ##QuantityAndTolrance##<td>
                            </tr>
                            <tr>
                                <td style="padding-bottom: 15px;">Price</td>
                                <td style="padding-bottom: 15px;">: ##Price##<td>
                            </tr>
                            <tr>
                                <td style="padding-bottom: 15px;">Basis</td>
                                <td style="padding-bottom: 15px;">: ##Basis##<td>
                            </tr>
                            <tr>
                                <td style="padding-bottom: 15px;">Weight / Quality</td>
                                <td style="padding-bottom: 15px;">: ##WeightPerQuantity##<td>
                            </tr>
                            <tr>
                                <td style="padding-bottom: 15px;">Shipment Period</td>
                                <td style="padding-bottom: 15px;">: ##ShipmentPeriod##<td>
                            </tr>
                            <tr>
                                <td style="padding-bottom: 15px;">Payment Term</td>
                                <td style="padding-bottom: 15px;">: ##PaymentTerm##<td>
                            </tr>
                            <tr>
                                <td style="padding-bottom: 15px;display: none"></td>
                                <td style="padding-bottom: 15px;">##TermsAndConditions##<td>
                            </tr>
                            
                            <tr>
                                <td style="padding-bottom: 15px;">Documents</td>
                                <td style="padding-bottom: 15px;">: ##Documents##<td>
                            </tr>
                        </table>
                    </div>
                </div>
                Please sign and return if not signed within 48 hrs. its deemed contract Confirmed and Accepted by both parties:
Confirmed and Accepted by both parties:
                <div class="row" style="margin-top: 100px;">
                    <div class="col-6">
                        <hr style="border-top: 3px dotted; width: 315px;">
                        <p class="sub-heading" style="text-align: center; margin-bottom: 15px;">##SellerName##</p>
                        <p class="sub-heading" style="text-align: center;">(As SELLERS)</p>
                    </div>
                     <div class="col-6">
                        <hr style="border-top: 3px dotted; width: 315px;">
                        <p class="sub-heading" style="text-align: center; margin-bottom: 15px;">##BuyerName##</p>
                        <p class="sub-heading" style="text-align: center;">(As BUYERS)</p>
                    </div>
                </div>   
            </div>    
        </div>      
    </body>
    </html>','Contract Details in PDF',N'44BEC309-746E-424E-8700-37219FC7C505')
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
	        --SwitchBL buyer contract acceptence by SGTrader
           (NEWID(), N'##CompanyLogo##', N'44BEC309-746E-424E-8700-37219FC7C505','This is a URL for company logo', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##CompanyName##', N'44BEC309-746E-424E-8700-37219FC7C505','Company name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##CompanyAddress##',N'44BEC309-746E-424E-8700-37219FC7C505','Address of the company', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##RegistrationNumberAndPhoneNumber##',N'44BEC309-746E-424E-8700-37219FC7C505','Registration and phone number of company', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##ContractType##',N'44BEC309-746E-424E-8700-37219FC7C505','Contract type denotes type of the contract', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##ContractNo##',N'44BEC309-746E-424E-8700-37219FC7C505','This number is given for every contract', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##ContractDate##',N'44BEC309-746E-424E-8700-37219FC7C505','This date denotes contract created date', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##SellerAddress##',N'44BEC309-746E-424E-8700-37219FC7C505','Address of the seller', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##BuyerAddress##',N'44BEC309-746E-424E-8700-37219FC7C505','Address of the buyer', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##ProductName##',N'44BEC309-746E-424E-8700-37219FC7C505','Product which is buyed or selled in a contract', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##Origin##',N'44BEC309-746E-424E-8700-37219FC7C505','This is the origin of the contract', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##Specifications##',N'44BEC309-746E-424E-8700-37219FC7C505','This is the specification of the contract', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##QuantityAndTolrance##',N'44BEC309-746E-424E-8700-37219FC7C505','This is the quantity and tolerance', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##Price##',N'44BEC309-746E-424E-8700-37219FC7C505','This is total price of the contract', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##Basis##',N'44BEC309-746E-424E-8700-37219FC7C505','This is the basis of the contract', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##WeightPerQuantity##',N'44BEC309-746E-424E-8700-37219FC7C505','This is the weight of the contract', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##ShipmentPeriod##',N'44BEC309-746E-424E-8700-37219FC7C505','Duration which contract must complete', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PaymentTerm##',N'44BEC309-746E-424E-8700-37219FC7C505','This is the payment of the contract', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##Demurrage##',N'44BEC309-746E-424E-8700-37219FC7C505','This is the demurrage of the contract', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##ImportDuties##',N'44BEC309-746E-424E-8700-37219FC7C505','This is the import duties ', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##ExportDuties##',N'44BEC309-746E-424E-8700-37219FC7C505','This is the export duties', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##TermsAndConditions##',N'44BEC309-746E-424E-8700-37219FC7C505','Terms and conditions of the contract', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##InsuranceAndTransferRisk##',N'44BEC309-746E-424E-8700-37219FC7C505','This is the contract insurance and transfer risk', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##Documents##',N'44BEC309-746E-424E-8700-37219FC7C505','This is the documents of the contract which are included in contract', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##SellerName##',N'44BEC309-746E-424E-8700-37219FC7C505','Seller name who is included in contract as seller', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##BuyerName##',N'44BEC309-746E-424E-8700-37219FC7C505','Buyer name who is included in contract as buyer', @CompanyId, GETDATE(), @UserId, NULL)
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
