----------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-02-24 00:00:00.000'
-- Purpose      To Update or insert Workspace filters
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertWorkspaceFilter] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-- , @DashboardId = '9CBEC8B0-8DB2-41D9-A8D8-BFC8C505CD4B'
-- ,@FiltersXml = '<ArrayOfFilterKeyValuePair><FilterKeyValuePair><FilterId xsi:nil="true" />
--  <FilterKey>test</FilterKey></FilterKeyValuePair><FilterKeyValuePair><FilterId xsi:nil="true" />
--  <FilterKey>test2</FilterKey></FilterKeyValuePair></ArrayOfFilterKeyValuePair>'
----------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertWorkspaceFilter]
(	
	@ReferenceId UNIQUEIDENTIFIER = NULL,
	@FiltersXml XML = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	
	SET NOCOUNT ON 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		
		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL;
		
		IF(@ReferenceId = '00000000-0000-0000-0000-000000000000') SET @ReferenceId = NULL;
		
		IF(@ReferenceId IS NULL)
		BEGIN
			
			RAISERROR(50011,11,1,'DashboardId')

		END
		ELSE IF(@FiltersXml IS NULL)
		BEGIN
			
			RAISERROR(50011,11,1,'DashboardFilters')

		END
		ELSE
		BEGIN
			
			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
            BEGIN

				DECLARE @CurrentDate DATETIME = GETDATE()

				DECLARE @FilterList TABLE
				(
					FilterId UNIQUEIDENTIFIER NULL,
					FilterParameter NVARCHAR(250),
					FilterValue NVARCHAR(500),
					FilterName NVARCHAR(500),
					IsNewParameter BIT DEFAULT 0,
					IsSystemFilter BIT DEFAULT 0
				)

				INSERT INTO @FilterList(FilterId,FilterParameter,FilterValue,IsSystemFilter,FilterName)
				SELECT X.Y.value('(FilterId/text())[1]','UNIQUEIDENTIFIER')
				       ,X.Y.value('(FilterKey/text())[1]','NVARCHAR(250)')
				       ,X.Y.value('(FilterValue/text())[1]','NVARCHAR(500)')
				       ,X.Y.value('(IsSystemFilter/text())[1]','BIT')
				       ,X.Y.value('(FilterName/text())[1]','NVARCHAR(500)')
				FROM @FiltersXml.nodes('/ArrayOfFilterKeyValuePair/FilterKeyValuePair') AS X(Y)
				
				DECLARE @ParameterNameCount INT = 0

				UPdATE @FilterList SET FilterId = WSP.Id
				FROM @FilterList F INNeR jOIN WorkspaceParameter WSP On WSP.CreatedByUserId = @OperationsPerformedBy
					 AND WSP.ReferenceId = @ReferenceId AND F.FilterParameter = WSP.ParameterName
					 
					 SET @ParameterNameCount  = (SELECT COUNT(1) FROM WorkspaceParameter 
				                            WHERE ParameterName COLLATE SQL_Latin1_General_CP1_CI_AS 
											IN (SELECT FilterParameter FROM @FilterList 
											         WHERE FilterId IS NULL AND CreatedByUserId = @OperationsPerformedBy)
				                                  AND ReferenceId = @ReferenceId AND InActiveDateTime IS NULL)
				
				UPDATE @FilterList SET IsNewParameter = 1,FilterId = NEWID()
				FROM @FilterList FL 
				LEFT JOIN WorkspaceParameter WP ON FL.FilterId = WP.Id AND @ReferenceId = WP.ReferenceId
				WHERE WP.Id IS NULL

				IF(EXISTS(SELECT FilterParameter FROM @FilterList GROUP BY FilterParameter 
							  HAVING COUNT(FilterParameter) > 1 ))
				BEGIN
				   	
				  RAISERROR(50024,16,1)
						
				END
				ELSE IF(@ParameterNameCount > 0)
				BEGIN
					
					RAISERROR(50001,11,1,'Perameter')

				END
				ELSE
				BEGIN

					INSERT INTO WorkspaceParameter(
						Id
						,ReferenceId
						,ParameterName
						,CreatedByUserId
						,CreatedDateTime
						,IsSystemFilter
						,ParameterLabel
					)
					SELECT FL.FilterId
					       ,@ReferenceId
					       ,FL.FilterParameter
						   ,@OperationsPerformedBy
						   ,@CurrentDate
						   ,FL.IsSystemFilter
						   ,FL.FilterName
					FROM @FilterList FL
					WHERE IsNewParameter = 1
					
					UPDATE WorkspaceFilter
						   SET FilterValue = FL.FilterValue
						       ,UpdatedDateTime = @CurrentDate 
					FROM WorkspaceFilter WF
					     INNER JOIN @FilterList FL ON FL.FilterId = WF.WorkspaceParameterId AND WF.CreatedByUserId = @OperationsPerformedBy

					INSERT INTO WorkspaceFilter
					(
						Id
						,WorkspaceParameterId
						,FilterValue
						,CreatedByUserId
						,CreatedDateTime
					)
					SELECT NEWID()
					       ,FL.FilterId
						   ,FL.FilterValue
						   ,@OperationsPerformedBy
						   ,@CurrentDate
					FROM @FilterList FL
					      LEFT JOIN WorkspaceFilter WF ON FL.FilterId = WF.WorkspaceParameterId AND WF.CreatedByUserId = @OperationsPerformedBy
					WHERE WF.Id IS NULL
				
				END

			END
		    ELSE
			BEGIN
                    RAISERROR (@HavePermission,11, 1)
                    
            END

		END

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH

END
GO
