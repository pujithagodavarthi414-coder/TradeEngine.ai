-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Save or Update the ButtonTypes
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertButtonType]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ButtonTypeName='Test'
CREATE PROCEDURE [dbo].[USP_UpsertButtonType]
(
   @ButtonTypeName  NVARCHAR(250) = NULL,
   @ButtonTypeId UNIQUEIDENTIFIER = NULL,
   @ShortName  NVARCHAR(250) = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        IF (@HavePermission = '1')
        BEGIN
			 DECLARE @Currentdate DATETIME = GETDATE()
			 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			 DECLARE @ButtonTypeIdCount INT = (SELECT COUNT(1) FROM ButtonType WHERE Id = @ButtonTypeId AND CompanyId = @CompanyId)
			 DECLARE @ButtonTypeNameCount INT = (SELECT COUNT(1) FROM ButtonType WHERE ButtonTypeName = @ButtonTypeName AND CompanyId = @CompanyId AND (@ButtonTypeId IS NULL OR Id <> @ButtonTypeId))
	         IF(@ButtonTypeIdCount = 0 AND @ButtonTypeId IS NOT NULL)
		     BEGIN
		     	RAISERROR(50002,16, 1,'ButtonType')
		     END
		     ELSE IF(@ButtonTypeNameCount > 0)
		     BEGIN
		     	RAISERROR(50001,16,1,'ButtonType')
		     END
		     ELSE
		     BEGIN
				 DECLARE @IsLatest BIT = (CASE WHEN @ButtonTypeId IS NULL
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM ButtonType WHERE Id = @ButtonTypeId) = @TimeStamp
																THEN 1 ELSE 0 END END)
				 IF(@IsLatest = 1)
				 BEGIN
				
				IF(@ButtonTypeId IS NULL)
				BEGIN

				SET @ButtonTypeId = NEWID()
				INSERT INTO [dbo].[ButtonType](
		     	                 [Id],
		     				     [ButtonTypeName],
		     				     [CompanyId],
								 [InActiveDateTime],
		     				     [CreatedDateTime],
		     				     [CreatedByUserId],
								 [IsStart],
								 [IsBreakIn],
								 [BreakOut],
								 [IsLunchStart],
								 [IsLunchEnd],
								 [IsFinish],
								 [ButtonCode],
								 [ShortName]
								 )
		     	         SELECT  @ButtonTypeId,
		     				     @ButtonTypeName,
		     				     @CompanyId,
								 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
		     				     @Currentdate,
		     				     @OperationsPerformedBy,
		     			         IsStart,
								 IsBreakIn,
								 BreakOut,
								 IsLunchStart,
								 IsLunchEnd,
								 IsFinish,
								 ButtonCode,
								 @ShortName
				    	FROM ButtonType WHERE Id = @ButtonTypeId

				END
				ELSE
				BEGIN

						UPDATE [dbo].[ButtonType]
							SET [ButtonTypeName]	=	 @ButtonTypeName,
		     				     [CompanyId]		=	 @CompanyId,
								 [InActiveDateTime]	=	 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
		     				     [UpdatedDateTime]	=	 @Currentdate,
		     				     [UpdatedByUserId]	=	 @OperationsPerformedBy,
								 [IsStart]			=	 IsStart,
								 [IsBreakIn]		=	 IsBreakIn,
								 [BreakOut]			=	 BreakOut,
								 [IsLunchStart]		=	 IsLunchStart,
								 [IsLunchEnd]		=	 IsLunchEnd,
								 [IsFinish]			=	 IsFinish,
								 [ButtonCode]		=	 ButtonCode,
								 [ShortName]		=	 @ShortName
						WHERE Id = @ButtonTypeId
				END
		     		SELECT Id FROM [dbo].[ButtonType] WHERE Id = @ButtonTypeId
				 END	
				 ELSE
			  	 	RAISERROR (50008,11, 1)
            END
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
GO
