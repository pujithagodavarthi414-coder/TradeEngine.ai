CREATE PROCEDURE [dbo].[Marker9]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER,
    @Marker NVARCHAR(100) = NULL
)
AS 
BEGIN 
SET NOCOUNT ON
BEGIN TRY

MERGE INTO [dbo].[Currency] AS Target
USING ( VALUES
     (NEWID(),@CompanyId, N'United States Dollar', N'USD', N'$',  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
)
AS Source ([Id], [CompanyId], [CurrencyName], [CurrencyCode], [Symbol], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CompanyId] = Source.[CompanyId],
           [CurrencyName] = source.[CurrencyName],
           [CurrencyCode] = source.[CurrencyCode],
           [Symbol] = source.[Symbol],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [CurrencyName], [CurrencyCode], [Symbol], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [CompanyId], [CurrencyName], [CurrencyCode], [Symbol], [CreatedDateTime], [CreatedByUserId]);
MERGE INTO [dbo].[Currency] AS Target
USING ( VALUES
     (NEWID(),@CompanyId, N'Albanian Lek', N'ALL', N'L',  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'Canadian Dollar', N'CAD', N'$',  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'Nepalese Rupee', N'NPR', N'₹',  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'Fizzi Dollar', N'FJD', N'$',  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'Hongkong Dollar', N'HKD', N'$',  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'Indonesian Rupaiah', N'IDR', N'Rp', CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'Bolivian Boliviano', N'BOB', N'$b',  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'Hungarian Forient', N'HUF', N'Ft', CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'Indian Rupee', N'INR', N'₹',CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'Australian Dollar', N'AUD', N'$', CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'Euro', N'EUR', N'€', CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'Brazilian Real', N'BRL', N'R$',  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'Afganisthan Afgani', N'AFN', N'Af',  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'Iceland Krona', N'ISK', N'Kr',  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'Algerian Dinar', N'DZD', N'دج',  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'United States Dollar', N'USD', N'$',  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
    ,(NEWID(),@CompanyId, N'Pound Sterling', N'GBP', N'£',  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
)
AS Source ([Id], [CompanyId], [CurrencyName], [CurrencyCode], [Symbol], [CreatedDateTime], [CreatedByUserId])
ON Target.CurrencyName = Source.CurrencyName
WHEN MATCHED THEN
UPDATE SET [Symbol] = source.[Symbol];
MERGE INTO [dbo].[InvoiceStatus] AS Target
USING ( VALUES
 --(NEWID(), N'All unpaid', N'#eaeaea', CAST(N'2020-02-28T19:05:05.863' AS DateTime), @UserId, @CompanyId, NULL),
 --(NEWID(), N'Open', N'#eaeaea', CAST(N'2020-02-28T19:05:05.863' AS DateTime), @UserId, @CompanyId, NULL),
 --(NEWID(), N'Sent', N'#eaeaea', CAST(N'2020-02-28T19:05:05.863' AS DateTime), @UserId, @CompanyId, NULL),
 --(NEWID(), N'Viewed', N'#eaeaea', CAST(N'2020-02-28T19:05:05.863' AS DateTime), @UserId, @CompanyId, NULL),
 --(NEWID(), N'Payment failed', N'#ff194a', CAST(N'2020-02-28T19:05:05.863' AS DateTime), @UserId, @CompanyId, NULL),
 --(NEWID(), N'Refunded', N'#eaeaea', CAST(N'2020-02-28T19:05:05.863' AS DateTime), @UserId, @CompanyId, NULL),
 (NEWID(), N'Partial', N'#f6a623', CAST(N'2020-02-28T19:05:05.863' AS DateTime), @UserId, @CompanyId, NULL),
 (NEWID(), N'Paid', N'#00d478', CAST(N'2020-02-28T19:05:05.863' AS DateTime), @UserId, @CompanyId, NULL),
 --(NEWID(), N'Closed', N'#00d478', CAST(N'2020-02-28T19:05:05.863' AS DateTime), @UserId, @CompanyId, NULL),
 (NEWID(), N'Draft', N'#858c99', CAST(N'2020-02-28T19:05:05.863' AS DateTime), @UserId, @CompanyId, NULL)
)
AS Source ([Id], [InvoiceStatusName], [InvoiceStatusColor], [CreatedDateTime], [CreatedByUserId], [CompanyId], [InActiveDateTime])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [InvoiceStatusName] = Source.[InvoiceStatusName],
           [InvoiceStatusColor] = source.[InvoiceStatusColor],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CompanyId] = Source.[CompanyId],
           [InActiveDateTime] = Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [InvoiceStatusName], [InvoiceStatusColor], [CreatedDateTime], [CreatedByUserId], [CompanyId], [InActiveDateTime]) 
VALUES ([Id], [InvoiceStatusName], [InvoiceStatusColor], [CreatedDateTime], [CreatedByUserId], [CompanyId], [InActiveDateTime]);
UPDATE [dbo].[SoftLabelConfigurations] SET [EstimateLabel] = N'Estimate', [EstimatesLabel] = N'Estimates'
MERGE INTO [dbo].[PaymentMethod] AS Target 
USING ( VALUES 
  (NEWID(),@CompanyId, N'Check',             CAST(N'2020-03-14T16:40:33.207' AS DateTime), @UserId, NULL),
  (NEWID(),@CompanyId, N'Credit card',       CAST(N'2020-03-14T16:38:32.420' AS DateTime), @UserId, NULL),
  (NEWID(),@CompanyId, N'Cash',              CAST(N'2020-03-14T16:38:32.420' AS DateTime), @UserId, NULL),
  (NEWID(),@CompanyId, N'Bank transfer/ACH', CAST(N'2020-03-14T16:38:32.420' AS DateTime), @UserId, NULL),
  (NEWID(),@CompanyId, N'Paypal',            CAST(N'2020-03-14T16:38:32.420' AS DateTime), @UserId, NULL)
) 
AS Source ([Id], [CompanyId], [PaymentMethodName], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CompanyId]  = Source.[CompanyId],
           [PaymentMethodName] = Source.[PaymentMethodName],
           [InActiveDateTime] = Source.[InActiveDateTime],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [CompanyId], [PaymentMethodName], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime])
VALUES ([Id], [CompanyId], [PaymentMethodName], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]);
MERGE INTO [dbo].[AccountType] AS Target 
USING ( VALUES 
  (NEWID(),@CompanyId, N'Cash',                          CAST(N'2020-03-14T16:40:33.207' AS DateTime), @UserId, NULL),
  (NEWID(),@CompanyId, N'Checking',                      CAST(N'2020-03-14T16:38:32.420' AS DateTime), @UserId, NULL),
  (NEWID(),@CompanyId, N'Savings',                       CAST(N'2020-03-14T16:38:32.420' AS DateTime), @UserId, NULL),
  (NEWID(),@CompanyId, N'Short-term investments',        CAST(N'2020-03-14T16:38:32.420' AS DateTime), @UserId, NULL),
  (NEWID(),@CompanyId, N'Money market',                  CAST(N'2020-03-14T16:38:32.420' AS DateTime), @UserId, NULL),
  (NEWID(),@CompanyId, N'Trust accounts',                CAST(N'2020-03-14T16:38:32.420' AS DateTime), @UserId, NULL),
  (NEWID(),@CompanyId, N'Rents held in trust',           CAST(N'2020-03-14T16:38:32.420' AS DateTime), @UserId, NULL),
  (NEWID(),@CompanyId, N'Other earmarked bank accounts', CAST(N'2020-03-14T16:38:32.420' AS DateTime), @UserId, NULL)
) 
AS Source ([Id], [CompanyId], [AccountTypeName], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CompanyId]  = Source.[CompanyId],
           [AccountTypeName] = Source.[AccountTypeName],
           [InActiveDateTime] = Source.[InActiveDateTime],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [CompanyId], [AccountTypeName], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime])
VALUES ([Id], [CompanyId], [AccountTypeName], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]);


MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
    (NEWID(),N'This app provides the list of invoices', N'Invoices', CAST(N'2020-02-26 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
    --(NEWID(),N'By using this app we can manage the invoices', N'Add invoice', CAST(N'2020-02-26 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
    (NEWID(),N'This app provides the list of expense categories and the details of each expense category.User can configure the details for each expense category and can also search and sort the details.', N'Expense category', CAST(N'2020-02-26 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
    (NEWID(),N'This app provides the list of merchants and details of each merchant.User can configure the details of each merchant and can also search and sort the details of merchants.', N'Merchants', CAST(N'2020-02-26 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
    (NEWID(),N'This app provides the list of invoice statuses', N'Invoice status', CAST(N'2020-03-05 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
    (NEWID(),N'This app provides the list of estimates', N'Estimates', CAST(N'2020-03-06 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
)
AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
ON Target.Id = Source.Id 
WHEN MATCHED THEN 
UPDATE SET [WidgetName] = Source.[WidgetName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CompanyId] =  Source.[CompanyId],
           [Description] =  Source.[Description],
           [UpdatedDateTime] =  Source.[UpdatedDateTime],
           [UpdatedByUserId] =  Source.[UpdatedByUserId],
           [InActiveDateTime] =  Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

UPDATE [dbo].[AppSettings] SET AppSettingsValue = 'Marker9' WHERE AppSettingsName = 'Marker'
    
END TRY  
BEGIN CATCH 
        
         EXEC USP_GetErrorInformation
END CATCH
END
GO