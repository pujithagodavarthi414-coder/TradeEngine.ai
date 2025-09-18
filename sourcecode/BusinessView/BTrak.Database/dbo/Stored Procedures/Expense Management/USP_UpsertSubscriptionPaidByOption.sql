---------------------------------------------------------------------------------
---- Author       Padmini Badam
---- Created      '2019-05-18 00:00:00.000'
---- Purpose      To Save or update the SubscriptionPaidBy
---- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
----EXEC [dbo].[USP_UpsertSubscriptionPaidByOption] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@SubscriptionPaidByName='Test',@IsArchived = 0
---------------------------------------------------------------------------------
--CREATE PROCEDURE [dbo].[USP_UpsertSubscriptionPaidByOption]
--(
--   @SubscriptionPaidById UNIQUEIDENTIFIER = NULL,
--   @SubscriptionPaidByName NVARCHAR(800)  = NULL,
--   @IsArchived BIT = NULL,
--   @TimeStamp TIMESTAMP = NULL,
--   @OperationsPerformedBy UNIQUEIDENTIFIER
--)
--AS
--BEGIN
--	SET NOCOUNT ON
--	BEGIN TRY
--	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

--		IF(@SubscriptionPaidByName = '') SET @SubscriptionPaidByName = NULL

--		IF(@IsArchived = 1 AND @SubscriptionPaidById IS NOT NULL)
--        BEGIN
		
--		      DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
--	          IF(EXISTS(SELECT OriginalId FROM [EmployeeMembership] WHERE SubscriptionId = @SubscriptionPaidById AND AsAtInactiveDateTime IS NULL))
--	          BEGIN
	          
--	          SET @IsEligibleToArchive = 'ThisSubscriptionUsedInEmployeeMemberShipDeleteTheDependenciesAndTryAgain'
	          
--	          END
		      
--		      IF(@IsEligibleToArchive <> '1')
--		      BEGIN
		      
--		          RAISERROR (@isEligibleToArchive,11, 1)
		      
--		      END

--	    END

--	    IF(@SubscriptionPaidByName IS NULL)
--		BEGIN
		   
--		    RAISERROR(50011,16, 2, 'SubscriptionPaidByName')

--		END
--		ELSE
--		BEGIN

--		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

--		DECLARE @SubscriptionPaidByIdCount INT = (SELECT COUNT(1) FROM SubscriptionPaidBy WHERE OriginalId = @SubscriptionPaidById AND CompanyId = @CompanyId AND AsAtInactiveDateTime IS NULL)

--		DECLARE @SubscriptionPaidByNameCount INT = (SELECT COUNT(1) FROM SubscriptionPaidBy WHERE SubscriptionPaidByName = @SubscriptionPaidByName AND CompanyId = @CompanyId AND (OriginalId <> @SubscriptionPaidById OR @SubscriptionPaidById IS NULL) AND InActiveDateTime IS NULL AND AsAtInactiveDateTime IS NULL)

--		IF(@SubscriptionPaidByIdCount = 0 AND @SubscriptionPaidById IS NOT NULL)
--		BEGIN
--			RAISERROR(50002,16, 1,'SubscriptionPaidBy')
--		END

--		ELSE IF(@SubscriptionPaidByNameCount > 0)
--		BEGIN

--			RAISERROR(50001,16,1,'SubscriptionPaidBy')

--		END		

--		ELSE
--		BEGIN

--			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
--			IF (@HavePermission = '1')
--			BEGIN
				
--				DECLARE @IsLatest BIT = (CASE WHEN @SubscriptionPaidById IS NULL 
--				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
--			                                                           FROM SubscriptionPaidBy WHERE OriginalId = @SubscriptionPaidById AND AsAtInactiveDateTime IS NULL) = @TimeStamp
--																THEN 1 ELSE 0 END END)
			
--			    IF(@IsLatest = 1)
--				BEGIN

--					DECLARE @Currentdate DATETIME = GETDATE()
			        
--			        DECLARE @NewSubscriptionPaidById UNIQUEIDENTIFIER = NEWID()
			        
--			        DECLARE @VersionNumber INT
			        
--			        SELECT @VersionNumber = VersionNumber FROM SubscriptionPaidBy WHERE OriginalId = @SubscriptionPaidById AND AsAtInactiveDateTime IS NULL
			
--			        UPDATE SubscriptionPaidBy SET AsAtInactiveDateTime = @CurrentDate WHERE OriginalId = @SubscriptionPaidById AND AsAtInactiveDateTime IS NULL

--			        INSERT INTO [dbo].SubscriptionPaidBy(
--			                    [Id],
--			                    [SubscriptionPaidByName],
--			                    [InActiveDateTime],
--			                    [CreatedDateTime],
--			                    [CreatedByUserId],
--			                    [VersionNumber],
--			                    [OriginalId],
--								CompanyId)
--			             SELECT @NewSubscriptionPaidById,
--			                    @SubscriptionPaidByName,
--			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
--			                    @Currentdate,
--			                    @OperationsPerformedBy,
--			                    ISNULL(@VersionNumber,0) + 1,
--			                    ISNULL(@SubscriptionPaidById,@NewSubscriptionPaidById),
--								@CompanyId
			       
--			        SELECT OriginalId FROM [dbo].SubscriptionPaidBy WHERE Id = @NewSubscriptionPaidById

--					END	
--					ELSE

--			  		RAISERROR (50008,11, 1)
--				END
				
--				ELSE
--				BEGIN

--						RAISERROR (@HavePermission,11, 1)
						
--				END
--			END
--	    END
--	END TRY
--	BEGIN CATCH

--		THROW

--	END CATCH

--END
--GO