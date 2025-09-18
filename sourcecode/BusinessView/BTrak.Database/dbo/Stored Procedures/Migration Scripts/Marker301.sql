CREATE PROCEDURE [dbo].[Marker301]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN
SET NOCOUNT ON


	MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
	(NEWID(),'Phone Number',
	'SELECT Name, CONCAT(SC.CountryCode, MobileNumber) MobileNumber  FROM (  SELECT JSON_VALUE(FormJson, ''$.displayName'') [Name], JSON_VALUE(FormJson, ''$.mobileNumber'') [MobileNumber], CreatedByUserId FROM GenericFormSubmitted  where JSON_VALUE(FormJson, ''$.externalUserId'') in (   SELECT distinct JSON_VALUE(FormJson, ''$.externalUserId'') FROM GenericFormSubmitted  where JSON_VALUE(FormJson, ''$.accountNo'') in (    SELECT distinct JSON_VALUE(FormJson, ''$.accountNo'')  from GenericFormSubmitted where Id=@FormId     )   and JSON_VALUE(FormJson, ''$.externalUserId'') <> ''''  ) and JSON_VALUE(FormJson, ''$.role'') <> ''''   UNION   SELECT JSON_VALUE(INNERDETAILS.value, ''$.memberName'') [Name],  JSON_VALUE(INNERDETAILS.value, ''$.memberMobileNumber'') [mobileNumber], CreatedByUserId FROM GenericFormSubmitted GFS  CROSS APPLY OPENJSON(FormJson) AS DETAILS  CROSS APPLY OPENJSON(DETAILS.VALUE) AS INNERDETAILS  WHERE ISJSON(DETAILS.value) = 1 and  Id in (SELECT distinct Id FROM GenericFormSubmitted  where JSON_VALUE(FormJson, ''$.externalUserId'') in (   SELECT distinct JSON_VALUE(FormJson, ''$.externalUserId'') FROM GenericFormSubmitted  where JSON_VALUE(FormJson, ''$.accountNo'') in (    SELECT distinct JSON_VALUE(FormJson, ''$.accountNo'')  from GenericFormSubmitted where Id=@FormId     )   and JSON_VALUE(FormJson, ''$.externalUserId'') <> ''''  ) and JSON_VALUE(FormJson, ''$.role'') <> '''')  and JSON_VALUE(INNERDETAILS.value, ''$.memberName'') <> '''' and JSON_VALUE(INNERDETAILS.value, ''$.memberMobileNumber'') <> '''' ) INNERTBL INNER JOIN [User] U ON U.Id = INNERTBL.CreatedByUserId INNER JOIN Company CN ON CN.Id= U.CompanyId INNER JOIN SYS_Country SC ON SC.ID = CN.CountryId',@CompanyId, 1)
  )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId], [IsQuery])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
  WHEN MATCHED THEN 
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery],
				[IsQuery] = SOURCE.[IsQuery];

END