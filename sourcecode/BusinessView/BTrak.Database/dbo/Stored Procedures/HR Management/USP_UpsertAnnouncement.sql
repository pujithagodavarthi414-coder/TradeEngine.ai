-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-06-27 00:00:00.000'
-- Purpose      To save or update announcement
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------------------------------------
--EXEC  [dbo].[USP_UpsertAnnouncement] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertAnnouncement]
(
 @AnnouncementId UNIQUEIDENTIFIER = NULL,
 @Announcement NVARCHAR(MAX) = NULL,
 @AnnouncedTo NVARCHAR(MAX) = NULL,
 @AnnouncementLevel INT = NULL,
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
			
			IF (@AnnouncementId =  '00000000-0000-0000-0000-000000000000') SET @AnnouncementId = NULL

			IF (@Announcement = ' ' ) SET @Announcement = NULL

			BEGIN

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @AnnouncementIdCount INT = (SELECT COUNT(1) FROM Announcement WHERE Id = @AnnouncementId AND CompanyId = @CompanyId )
				
				IF (@AnnouncementIdCount = 0 AND @AnnouncementId IS NOT NULL)
				BEGIN
				    
					RAISERROR(50002,16,1,'Announcement')

				END
				ELSE
				BEGIN
					
					DECLARE @CurrentDate DATETIME = GETDATE()

					SET @IsArchived = ISNULL(@IsArchived,0)
					
					CREATE TABLE #AnnouncedToMembers
					(
						UserId UNIQUEIDENTIFIER
					)

					IF(@AnnouncementLevel = 0)
					BEGIN

						INSERT INTO #AnnouncedToMembers(UserId)
						SELECT U.Id
						FROM [User] U
						WHERE U.CompanyId = @AnnouncedTo --TODO
						      AND U.IsActive = 1
							  AND U.InActiveDateTime IS NULL

					END
					ELSE IF(@AnnouncementLevel = 1)
					BEGIN

						INSERT INTO #AnnouncedToMembers(UserId)
						SELECT U.Id 
						FROM [User] U
						     INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
							 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
							            AND EB.[ActiveFrom] <= GETDATE() AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
						WHERE U.CompanyId = @CompanyId
						      AND U.IsActive = 1
							  AND U.InActiveDateTime IS NULL
							  AND EB.BranchId IN (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@AnnouncedTo,','))

					END
					ELSE IF(@AnnouncementLevel = 2)
					BEGIN

						INSERT INTO #AnnouncedToMembers(UserId)
						SELECT U.Id 
						FROM [User] U
						     INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
						WHERE U.CompanyId = @CompanyId
						      AND U.IsActive = 1
							  AND U.InActiveDateTime IS NULL
							  AND E.Id IN (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@AnnouncedTo,','))

					END

					IF(@AnnouncementId IS NULL)
					BEGIN

					  SET @AnnouncementId = NEWID()

						  INSERT INTO Announcement(Id,
							    			Announcement,
											AnnouncedTo,
											AnnouncementLevel,
							    			CompanyId,
							    			CreatedDateTime,
							    			CreatedByUserId,
							    			InactiveDateTime
							    		   )
							    	SELECT  @AnnouncementId,
											@Announcement,
											@AnnouncedTo,
											@AnnouncementLevel,
							    			@CompanyId,
							    			@CurrentDate,
							    			@OperationsPerformedBy,
										    CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END

							INSERT INTO [dbo].[UserAnnouncementRead](
										Id
										,UserId
										,AnnouncementId
										,CreatedDateTime
										,CreatedByUserId)
								SELECT NEWID()
								       ,UserId
									   ,@AnnouncementId
									   ,GETDATE()
									   ,@OperationsPerformedBy
								FROM #AnnouncedToMembers
							      
					   END
					   ELSE
					   BEGIN

						 UPDATE [Announcement]
					     SET  [Announcement] = @Announcement,
							  AnnouncedTo = @AnnouncedTo,
							  AnnouncementLevel = @AnnouncementLevel,
							  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
							  UpdatedDateTime = @CurrentDate,
							  UpdatedByUserId = @OperationsPerformedBy
							 WHERE Id = @AnnouncementId

							IF(@IsArchived = 1)
							BEGIN

									 UPDATE [dbo].[UserAnnouncementRead] SET InActiveDateTime = @CurrentDate
									 WHERE AnnouncementId = @AnnouncementId

							END
							ELSE
							BEGIN
								
								UPDATE [UserAnnouncementRead] SET InActiveDateTime = CASE WHEN ATM.UserId IS NULL THEN @CurrentDate ELSE NULL END
								                                  ,UpdatedByUserId = @OperationsPerformedBy
																  ,UpdatedDateTime = @CurrentDate
								FROM [UserAnnouncementRead] UAR
								     LEFT JOIN #AnnouncedToMembers ATM ON UAR.AnnouncementId = @AnnouncementId
											           AND UAR.UserId = ATM.UserId
								WHERE UAR.AnnouncementId = @AnnouncementId

								INSERT INTO [dbo].[UserAnnouncementRead](
												Id
												,UserId
												,AnnouncementId
												,CreatedDateTime
												,CreatedByUserId)
										SELECT NEWID()
										       ,ATM.UserId
											   ,@AnnouncementId
											   ,GETDATE()
											   ,@OperationsPerformedBy
										FROM #AnnouncedToMembers ATM
										     LEFT JOIN [UserAnnouncementRead] UAR ON UAR.AnnouncementId = @AnnouncementId
											           AND UAR.UserId = ATM.UserId
										WHERE UAR.Id IS NULL

							END

					   END

					SELECT Id FROM Announcement WHERE Id = @AnnouncementId
					
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