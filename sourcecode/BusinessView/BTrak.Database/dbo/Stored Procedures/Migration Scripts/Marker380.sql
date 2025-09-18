CREATE PROCEDURE [dbo].[Marker380]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
	
    DECLARE @Currentdate DATETIME = GETDATE()
 
       DECLARE @Template TABLE
	   (
		 EmailTemplateName NVARCHAR(250)
		,[EmailTemplate] NVARCHAR(MAX)
		,[EmailSubject] NVARCHAR(2000)
        ,[EmailTemplateReferenceId] UNIQUEIDENTIFIER
	    )

        INSERT INTO @Template(EmailTemplateName,EmailTemplate,EmailSubject,EmailTemplateReferenceId)
	VALUES('UnsoldQuantityEmailAltert','<!DOCTYPE html>
<html>
<head>
<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>
</head>
<body>

  <b>Hello,</b>                                                
	   </p>                                                 
	   <p style="color:#262626; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif">This is the remaning unsold quantity to this  <b>##Contract##</b> contract</p>   
	   <table>
 ##TableData##
</table>

	   <p style="color:#262626; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif">Thank you</p>                                                 
	   <p                                                      style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                      Warm Regards, <br /> ##footerName## </p>  
</body>
</html>

','Contract Unsold Quantity',N'674EFA9D-C06F-49CD-9844-DCA48E389EB2') 

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
	            (NEWID(), N'##Contract##',N'674EFA9D-C06F-49CD-9844-DCA48E389EB2','This is the contract name in vessel contract', @CompanyId, GETDATE(), @UserId, NULL)
	    	   ,(NEWID(), N'##TableData##',N'674EFA9D-C06F-49CD-9844-DCA48E389EB2','This is the table data that will generate dynamically based on data', @CompanyId, GETDATE(), @UserId, NULL)
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
