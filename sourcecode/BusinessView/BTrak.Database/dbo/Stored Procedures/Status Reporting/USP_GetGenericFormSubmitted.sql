
---------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-09-30 00:00:00.000'
-- Purpose      To Get the Submitted Generic Forms by applying different filters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetGenericFormSubmitted] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetGenericFormSubmitted]
(
	@GenericFormSubmittedId UNIQUEIDENTIFIER = NULL,
	@FormId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER = NULL,
	@CustomApplicationId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT= NULL,
	@KeyName NVARCHAR(250) = NULL,
	@IsPagingRequired INT = 0,
	@PageNumber INT = 1,
    @PageSize INT = 10,
	@QuerytoFilter NVARCHAR(MAX) = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = '1'
		
		IF (@HavePermission = '1')
	    BEGIN
			IF(@KeyName = '') SET @KeyName = NULL
		  
			IF(@GenericFormSubmittedId = '00000000-0000-0000-0000-000000000000') SET @GenericFormSubmittedId = NULL		  
		   
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			IF(@IsArchived IS NULL) SET @IsArchived = 0
       	   
			IF(@KeyName IS NOT NULL) SET @KeyName = '$.' + @KeyName

			IF(@IsPagingRequired IS NULL)SET @IsPagingRequired = 0
			
			DECLARE @queryPatch NVARCHAR(MAX), @IsQueryAttached BIT
			
			IF(@QuerytoFilter IS NOT NULL)
			BEGIN 

				DECLARE @LoggedInUserQuery nvarchar(max)
				DECLARE @LoggedInUser nvarchar(max)
				select 
					@LoggedInUserQuery = 'select @LoggedInUser = JSON_VALUE(FormJson , CONCAT(''$.'',  ''' + ltrim(rtrim(SUBSTRING(Value, 0, CHARINDEX(':', Value)))) + ''') ) from	GenericFormSubmitted where FormId = '''+ convert(nvarchar(50), @FormId) +'''
											and  JSON_VALUE(formjson, CONCAT(''$.'',  ''' + SUBSTRING(Value, 0, CHARINDEX(':', Value)) +''' ) ) <> '''' 
											and JSON_VALUE(formjson, CONCAT(''$.'',  ''' + SUBSTRING(Value, 0, CHARINDEX(':', Value)) +''' ) ) in 
											(	
												select JSON_VALUE(FormJson, CONCAT(''$.'', ''externalUserId'') ) from GenericFormSubmitted 
												where JSON_VALUE(FormJson, ''$.email'') in (select UserName from [user] where id = '''+ convert(nvarchar(50),@OperationsPerformedBy) +''')
											)
										'
				FROM DBO.Ufn_StringSplit(@QuerytoFilter, ';') WHERE Value like '%@OperationsPerformedBy%'
				
				execute sp_executesql 
						@LoggedInUserQuery, 
						N'@LoggedInUser nvarchar(max) OUTPUT', 
						@LoggedInUser = @LoggedInUser output;
			
				SELECT @queryPatch = COALESCE(@queryPatch + ' and ' , '') +' CONVERT( NVARCHAR(MAX),  JSON_VALUE(GFS.FormJson, ''$.'+ ltrim(rtrim(REVERSE(PARSENAME(REPLACE(REVERSE(Value), ':', '.'), 1)))) + ''')) = '+ 
					 CASE WHEN  TRY_CONVERT(UNIQUEIDENTIFIER, LTRIM(RTRIM(REVERSE(PARSENAME(REPLACE(REVERSE(Value), ':', '.'), 2))))) IS NOT NULL THEN 
						  +  (select ' JSON_VALUE('''+ FormJson + ''' , ''$.'+ ltrim(rtrim(REVERSE(PARSENAME(REPLACE(REVERSE(Value), ':', '.'), 1))))  +''')'   from	GenericFormSubmitted where id = LTRIM(RTRIM(REVERSE(PARSENAME(REPLACE(REVERSE(Value), ':', '.'), 2)))))
					 ELSE
						'''' + REPLACE(LTRIM(RTRIM(REVERSE(PARSENAME(REPLACE(REVERSE(Value), ':', '.'), 2)))), '@OperationsPerformedBy', @LoggedInUser ) + ''''
					 END
					 + '' FROM DBO.Ufn_StringSplit(@QuerytoFilter, ';') WHERE Value <> '' AND ltrim(rtrim(REVERSE(PARSENAME(REPLACE(REVERSE(Value), ':', '.'), 1)))) not in( '' , 'customquery')

				IF EXISTS(SELECT * FROM DBO.Ufn_StringSplit(@QuerytoFilter, ';') WHERE ltrim(rtrim(REVERSE(PARSENAME(REPLACE(REVERSE(Value), ':', '.'), 1)))) in( '' , 'customquery'))
				BEGIN
					SET @IsQueryAttached  = 1;
					DECLARE @TableName NVARCHAR(100) = '##Temp' + CONVERT(VARCHAR(14),CONVERT(DECIMAL(14, 0), RAND() * POWER(CAST(10 AS BIGINT), 14)))
					declare @WidgetQuery nvarchar(max), @Query nvarchar(max)
					SELECT @WidgetQuery = WidgetQuery FROM CustomWidgets WHERE ID IN (SELECT ltrim(rtrim(REVERSE(PARSENAME(REPLACE(REVERSE(Value), ':', '.'), 2)))) FROM DBO.Ufn_StringSplit(@QuerytoFilter, ';') WHERE ltrim(rtrim(REVERSE(PARSENAME(REPLACE(REVERSE(Value), ':', '.'), 1)))) = 'customquery' )
					SET @Query = 'SELECT * INTO ' + @TableName + ' FROM ( ' + @WidgetQuery + ' ) T '
					EXEC(@Query)

				END
			END
		print @WidgetQuery
           DECLARE @SqlQuery NVARCHAR(4000) = ''
 
		SET @SqlQuery = 'SELECT GFS.Id AS GenericFormSubmittedId
					  ,GFS.CustomApplicationId
					  ,GFS.FormJson
					  ,CASE WHEN CA.IsApproveNeeded IS NULL THEN 0 ELSE 1 END AS IsApproveNeeded
					  ,GFS.UniqueNumber
					  ,CASE WHEN GFS.IsApproved IS NULL THEN 0 ELSE 1 END AS IsApproved
					  ,GFS.[TimeStamp]
					  ,GFS.CreatedByUserId
					  ,GFS.DataSetId
					  ,GFS.DataSourceId
					  ,GFS.CreatedDateTime
					  ,GFS.FormId
					  ,CASE WHEN @KeyName IS NOT NULL THEN JSON_VALUE(GFS.FormJson, ''' + ISNULL(@KeyName,'') + ''') ELSE NULL END AS KeyValue
					  ,CASE WHEN GFS.InActiveDateTime IS NULL THEN 0 ELSE 1 END AS IsArchived
					  , TotalCount = COUNT(1) OVER()
			   FROM GenericFormSubmitted GFS
				WHERE (@GenericFormSubmittedId IS NULL OR GFS.Id = @GenericFormSubmittedId)	
				AND (@CustomApplicationId IS NULL OR GFS.CustomApplicationId = @CustomApplicationId)
				AND (@FormId IS NULL OR GFS.FormId = @FormId)'
			   
		
		IF(@UserId IS NOT NULL) SET @SqlQuery = @SqlQuery + ' AND GFS.CreatedByUserId = @UserId '
		
		IF(@IsArchived IS NOT NULL AND @IsArchived = 1) SET @SqlQuery = @SqlQuery + ' AND GFS.InActiveDateTime IS NOT NULL '
		
		IF(@IsArchived IS NOT NULL AND @IsArchived = 0) SET @SqlQuery = @SqlQuery + ' AND GFS.InActiveDateTime IS NULL '

		IF (@queryPatch IS NOT NULL) SET @SqlQuery = @SqlQuery  + ' AND '+ @queryPatch;
		
		IF(@IsQueryAttached = 1) SET @SqlQuery = @SqlQuery  + ' AND GFS.Id in (SELECT FormId FROM '+@TableName+')'

        SET  @SqlQuery = @SqlQuery + ' ORDER BY GFS.CreatedDateTime DESC '

		IF(@IsPagingRequired = 1)SET  @SqlQuery = @SqlQuery+ ' OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
                                                               FETCH NEXT @PageSize ROWS ONLY'

		 

		EXEC SP_EXECUTESQL @SqlQuery,
		N'@GenericFormSubmittedId UNIQUEIDENTIFIER,
		  @FormId UNIQUEIDENTIFIER,
		  @OperationsPerformedBy UNIQUEIDENTIFIER,
		  @UserId UNIQUEIDENTIFIER,
		  @CustomApplicationId UNIQUEIDENTIFIER,
		  @IsArchived BIT,
		  @KeyName NVARCHAR(250),
		  @CompanyId UNIQUEIDENTIFIER,
		  @PageNumber INT,
		  @PageSize INT,
		  @IsQueryAttached BIT',
		  @GenericFormSubmittedId,
		  @FormId,
		  @OperationsPerformedBy,
		  @UserId,
		  @CustomApplicationId,
		  @IsArchived,
		  @KeyName,
		  @CompanyId,
		  @PageNumber ,
		  @PageSize ,
		  @IsQueryAttached

        END
	    ELSE
	    BEGIN
	    
	    		RAISERROR (@HavePermission,11, 1)
	    		
	    END
   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END