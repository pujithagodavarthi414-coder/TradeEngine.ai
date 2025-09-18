-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-06-27 00:00:00.000'
-- Purpose      To save or update MemberShips
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved 
-------------------------------------------------------------------------------------------------------------
--EXEC  [dbo].[USP_UpsertMemberShip] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@MemberShipType = 'Yearly'
-------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertMemberShip
(
 @MemberShipId UNIQUEIDENTIFIER = NULL,
 @MemberShipType NVARCHAR(50) = NULL,
 @TimeStamp TIMESTAMP = NULL,
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
			
			IF (@MemberShipId =  '00000000-0000-0000-0000-000000000000') SET @MemberShipId = NULL

			IF (@MemberShipType = ' ' ) SET @MemberShipType = NULL

			IF(@IsArchived = 1 AND @MemberShipId IS NOT NULL)
            BEGIN
		      
			  DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
			  
			  IF(EXISTS(SELECT Id FROM [EmployeeMembership] WHERE MembershipId = @MembershipId ))
			  BEGIN
			  
			  SET @IsEligibleToArchive = 'ThisMemberShipUsedInEmployeeMemberShipDeleteTheDependenciesAndTryAgain'
			  
			  END
		      
		      IF(@IsEligibleToArchive <> '1')
		      BEGIN
		      
		          RAISERROR (@isEligibleToArchive,11, 1)
		      
		      END

	        END

			IF (@MemberShipType IS NULL)
			BEGIN
				
				RAISERROR(50002,16,1,'MemberShip')

			END
			ELSE
			BEGIN

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @MemberShipIdCount INT = (SELECT COUNT(1) FROM MemberShip WHERE Id = @MemberShipId AND CompanyId = @CompanyId )
				
				DECLARE @MemberShipCount INT = (SELECT COUNT(1) FROM MemberShip WHERE MemberShipType = @MemberShipType AND (@MemberShipId IS NULL OR Id <> @MemberShipId) AND CompanyId = @CompanyId) 

				IF (@MemberShipIdCount = 0 AND @MemberShipId IS NOT NULL)
				BEGIN
				    
					RAISERROR(50002,16,1,'MemberShip')

				END
				ELSE IF(@MemberShipCount > 0)
				BEGIN
				
					RAISERROR(50001,16,1,'MemberShip')

				END
				ELSE
				BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @MemberShipId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM MemberShip WHERE Id = @MemberShipId) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest = 1) 
					BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

						IF(@MemberShipId IS NULL)
						BEGIN

						SET @MemberShipId = NEWID()

						INSERT INTO MemberShip( 
						                            Id,
													MemberShipType,
													CompanyId,
													CreatedDateTime,
													CreatedByUserId,
													InactiveDateTime
												   )
											SELECT  @MemberShipId,
											        @MemberShipType,
													@CompanyId,
													@CurrentDate,
													@OperationsPerformedBy,
													CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
													
							END
							ELSE
							BEGIN

						 UPDATE [MemberShip]
							 SET MemberShipType = @MemberShipType,
							     CompanyId = @CompanyId,
								 InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
								 UpdatedDateTime = @CurrentDate,
								 UpdatedByUserId = @OperationsPerformedBy
								 WHERE Id = @MemberShipId

							END

						SELECT Id FROM MemberShip WHERE Id = @MemberShipId
					END
					ELSE
					  
						RAISERROR(50008,11,1)

				END
			END
		END
		ELSE
			   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO