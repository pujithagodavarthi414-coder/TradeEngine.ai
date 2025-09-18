-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-06-27 00:00:00.000'
-- Purpose      To save or update badge for an employee
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------------------------------------
--EXEC  [dbo].[USP_AssignBadgeToEmployee] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_AssignBadgeToEmployee]
(
 @Id UNIQUEIDENTIFIER = NULL,
 @BadgeId UNIQUEIDENTIFIER = NULL,
 @BadgeDescription NVARCHAR(250) = NULL,
 @AssignedToXml XML = NULL,
 @IsArchived BIT = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@Id =  '00000000-0000-0000-0000-000000000000') SET @Id = NULL

			IF (@BadgeId =  '00000000-0000-0000-0000-000000000000') SET @BadgeId = NULL
			
			DECLARE @CurrentDate DATETIME = GETDATE()

			IF(@IsArchived = 1 AND @Id IS NOT NULL)
            BEGIN
					 
					DECLARE @OldValue NVARCHAR(MAX) = NULL
					DECLARE @NewValue NVARCHAR(MAX) = NULL
					DECLARE @Inactive DATETIME = NULL
					DECLARE @EmployeeId UNIQUEIDENTIFIER = NULL

					 UPDATE EmployeeBadge
					     SET  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
							  UpdatedDateTime = @CurrentDate,
							  UpdatedByUserId = @OperationsPerformedBy
							 WHERE Id = @Id
					
					SET @EmployeeId = (SELECT AssignedTo FROM EmployeeBadge WHERE Id = @Id)
					SET @Inactive = (SELECT InActiveDateTime FROM EmployeeBadge WHERE Id = @Id)
					SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					    
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Badge details',
					@FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue
		        
	        END
			ELSE
			BEGIN

				DECLARE @Employees TABLE
                (
					[Id] [uniqueidentifier]
                )
				
                INSERT INTO @Employees(Id)
                SELECT  [Table].[Column].value('(text())[1]', 'Nvarchar(250)')
                   FROM @AssignedToXml.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS [Table]([Column])

				INSERT INTO EmployeeBadge(Id,
				    			BadgeId,
								BadgeDescription,
								AssignedTo,
				    			CreatedDateTime,
				    			CreatedByUserId)
						SELECT  NEWID(),
								@BadgeId,
								@BadgeDescription,
								T.Id,
							    @CurrentDate,
							    @OperationsPerformedBy
						FROM @Employees T

			    INSERT INTO EmployeeDetailsHistory(
				                                  Id,
												  EmployeeId,
												  NewValue,
												  Category,
												  FieldName,
						                          CreatedDateTime,
												  CreatedByUserId
												  )
										   SELECT NEWID(),
										          T.Id,
												  (SELECT BadgeName FROM Badge WHERE Id = @BadgeId),
												  'Badge details',
												  'Badge',
												  GETDATE(),
												  @OperationsPerformedBy
												  FROM @Employees T


			END
		END
		ELSE
			   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END