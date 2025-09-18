--EXEC  [dbo].[USP_GetGenericFormSubmittedByKeyName] @CustomApplicationId='eb3d1f02-fb2d-4396-87b6-44a35ef7972b',
--@FormId='41eb95e3-305c-4346-90fc-2b42ac48396a',@KeyName='subjectNam1445e'

CREATE PROCEDURE [dbo].[USP_GetGenericFormSubmittedByKeyName]
(
	@GenericFormSubmittedId UNIQUEIDENTIFIER = NULL,
	@FormId UNIQUEIDENTIFIER = NULL,
    @UserId UNIQUEIDENTIFIER = NULL,
	@CustomApplicationId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT= NULL,
	@IsLatest BIT= NULL,
	@KeyName NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@CustomApplicationName NVARCHAR(250) = NULL,
	@FormName NVARCHAR(250) = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		    IF(@KeyName = '') SET @KeyName = NULL

			IF(@CustomApplicationName = '') SET @CustomApplicationName = NULL

			IF(@FormName = '') SET @FormName = NULL
			
		   IF(@GenericFormSubmittedId = '00000000-0000-0000-0000-000000000000') SET @GenericFormSubmittedId = NULL		
		   
		   IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL	  
		   
		   IF(@KeyName IS NOT NULL) SET @KeyName = '$.' + @KeyName

           DECLARE @SqlQuery NVARCHAR(4000) = ''

		   IF(ISNULL(@IsLatest,0) = 1)
		   BEGIN

		    SET @GenericFormSubmittedId =  (SELECT TOP 1  Id FROM GenericFormSubmitted WHERE (@CustomApplicationId IS NULL OR CustomApplicationId = @CustomApplicationId) AND (@FormId IS NULL OR FormId = @FormId)
			ORDER BY UniqueNumber DESC)

		   END
 
		SET @SqlQuery = 'SELECT GFS.Id AS GenericFormSubmittedId
					  ,GFS.CustomApplicationId
					  ,GFS.FormJson
					  ,GFS.UniqueNumber
					  ,GFS.[TimeStamp]
					  ,GFS.CreatedByUserId
					  ,GFS.CreatedDateTime
					  ,GF.FormJson AS FormSrc
					  ,GF.FormName
					  ,GFS.FormId
					  ,FA.IsAbleToLogin
					  ,CASE WHEN FA.IsAbleToPay = 1 AND EXISTS(SELECT * FROM UserRole ur WHERE USERID = @OperationsPerformedBy AND ur.RoleId IN (SELECT coalesce(FAR.ROLEiD, ur.RoleId)  FROM [FormAccessibilityRoleMapping] FAR WHERE FAR.FormId = GF.Id AND MapType = ''PAY'' AND InActiveDateTime IS NULL ))
							THEN CONVERT(BIT, 1) 
							ELSE CONVERT(BIT, 0) END IsAbleToPay
					  ,CASE WHEN FA.IsAbleToCall = 1 AND EXISTS(SELECT * FROM UserRole ur WHERE USERID = @OperationsPerformedBy AND ur.RoleId IN (SELECT coalesce(FAR.ROLEiD, ur.RoleId) FROM [FormAccessibilityRoleMapping] FAR WHERE FAR.FormId = GF.Id AND MapType = ''CALL'' AND InActiveDateTime IS NULL ))
							THEN CONVERT(BIT, 1) 
							ELSE CONVERT(BIT, 0) END IsAbleToCall
					  ,CASE WHEN FA.IsAbleToComment = 1 AND EXISTS(SELECT * FROM UserRole ur WHERE USERID = @OperationsPerformedBy AND ur.RoleId IN (SELECT coalesce(FAR.ROLEiD, ur.RoleId) FROM [FormAccessibilityRoleMapping] FAR WHERE FAR.FormId = GF.Id AND MapType = ''COMMENT'' AND InActiveDateTime IS NULL ))
							THEN CONVERT(BIT, 1) 
							ELSE CONVERT(BIT, 0) END IsAbleToComment
					  ,CASE WHEN @KeyName IS NOT NULL THEN JSON_VALUE(GFS.FormJson, ''' + ISNULL(@KeyName,'') + ''') ELSE NULL END AS KeyValue
					  ,CASE WHEN GFS.InActiveDateTime IS NULL THEN 0 ELSE 1 END AS IsArchived
			   FROM GenericFormSubmitted GFS
					LEFT JOIN CustomApplication CA ON CA.Id = GFS.CustomApplicationId '
		
		IF(@GenericFormSubmittedId IS NOT NULL) SET @SqlQuery = @SqlQuery + 'AND GFS.Id = @GenericFormSubmittedId '
					
		IF(@UserId IS NOT NULL) SET @SqlQuery = @SqlQuery + ' AND GFS.CreatedByUserId = @UserId '
		
		IF(@IsArchived IS NOT NULL AND @IsArchived = 1) SET @SqlQuery = @SqlQuery + ' AND GFS.InActiveDateTime IS NOT NULL '
		
		IF(@IsArchived IS NOT NULL AND @IsArchived = 0) SET @SqlQuery = @SqlQuery + ' AND GFS.InActiveDateTime IS NULL '

			SET @SqlQuery = @SqlQuery + ' INNER JOIN GenericForm GF ON GF.Id = GFS.FormId AND (@FormName IS NULL OR GF.FormName = @FormName) 
										  INNER JOIN FormType FT ON FT.Id = GF.FormTypeId '

		IF(@FormId IS NOT NULL) SET @SqlQuery = @SqlQuery + ' AND GFS.FormId = @FormId '

		IF(ISNULL(@IsLatest,0) = 1) SET @SqlQuery = @SqlQuery + ' AND GFS.Id = @GenericFormSubmittedId  '

			SET @SqlQuery = @SqlQuery + ' LEFT JOIN FormAccessibility FA ON FA.FormId = GF.Id 
			WHERE (@CustomApplicationName IS NULL OR CA.CustomApplicationName = @CustomApplicationName)  
			ORDER BY GFS.CreatedDateTime ASC '

		PRINT @SqlQuery;

		EXEC SP_EXECUTESQL @SqlQuery,
		N'@GenericFormSubmittedId UNIQUEIDENTIFIER,
		  @FormId UNIQUEIDENTIFIER,
		  @UserId UNIQUEIDENTIFIER,
		  @CustomApplicationId UNIQUEIDENTIFIER,
		  @IsArchived BIT,
		  @KeyName NVARCHAR(250),
		  @OperationsPerformedBy UNIQUEIDENTIFIER,
		  @CustomApplicationName NVARCHAR(250),
		  @FormName NVARCHAR(250)',
		  @GenericFormSubmittedId,
		  @FormId,
		  @UserId,
		  @CustomApplicationId,
		  @IsArchived,
		  @KeyName,
		  @OperationsPerformedBy,
		  @CustomApplicationName,
		  @FormName

   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END