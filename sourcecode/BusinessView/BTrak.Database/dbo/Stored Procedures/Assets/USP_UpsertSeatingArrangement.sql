-------------------------------------------------------------------------------
-- Author       Sai Praneeth M
-- Created      '2019-02-20 00:00:00.000'
-- Purpose      To Save or Update SeatingArrangement
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified By   Geetha Ch
-- Created      '2019-03-15 00:00:00.000' select * from  SeatingArrangement
-- Purpose      To Save or Update SeatingArrangement
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved select * from SeatingArrangement
---------------------------------------------------------------------------------
--EXEC USP_UpsertSeatingArrangement  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
--									 @EmployeeId = 'A3D2EA8F-046F-43D3-9F96-4773EB3FB225',
--									 @SeatCode = '70',
--									 @IsArchived = 0
--									 ,@BranchId = '1210DB37-93F7-4347-9240-E978A270B707'
---------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertSeatingArrangement]
(
   @SeatingId UNIQUEIDENTIFIER = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @SeatCode NVARCHAR(50) = NULL,
   @Description NVARCHAR(800) = NULL,
   @Comment NVARCHAR(800) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    

		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL

	    IF(@SeatCode = '') SET @SeatCode = NULL

	    IF (@BranchId IS NULL)
		BEGIN

			RAISERROR(50002,11,1,'Branch')

		END
		ELSE IF(@SeatCode IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'SeatCode')

		END
		ELSE
		BEGIN

		DECLARE @SeatingIdCount INT = (SELECT COUNT(1) FROM SeatingArrangement WHERE Id = @SeatingId)
        
		DECLARE @SeatingIdRelatedToAssets INT  = (SELECT COUNT(1) FROM Asset WHERE SeatingId = @SeatingId AND InactiveDateTime IS NULL)
		
        IF(@SeatingIdCount = 0 AND @SeatingId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 2,'SeatingArrangement')

        END
        ELSE IF(@IsArchived = 1 AND @SeatingIdRelatedToAssets>0)
		BEGIN
		
		RAISERROR('ThisSeatCodeIsLinkedToAssetsPleaseChangeTheSeatCodeAndTryToDeleteThisSeatCode',11,1)
		
		END
		ELSE
        BEGIN
           
			DECLARE @SeatingCodeCount INT = (SELECT COUNT(1) FROM SeatingArrangement 
		                                  WHERE BranchId = @BranchId 
		                                        AND SeatCode = @SeatCode AND InactiveDateTime IS NULL 
												AND (@SeatingId IS NULL OR Id <> @SeatingId))
            
         IF(@SeatingCodeCount > 0)
         BEGIN

         RAISERROR(50001,16,1,'SeatingArrangement')
           
         END
         ELSE
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @SeatingId IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [SeatingArrangement] WHERE Id = @SeatingId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			            IF(@IsLatest = 1)
			         	BEGIN
			         
			         	     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
							 IF(@SeatingId IS NULL)
							 BEGIN

								SET @SeatingId = NEWID()
								
								INSERT INTO [dbo].[SeatingArrangement](
								            [Id],
										    [BranchId],
										    [EmployeeId],
										    [SeatCode],
										    [Description],
										    [Comment],
										    [CreatedDateTime],
										    [CreatedByUserId],
										    [InactiveDateTime]
										    )
								  SELECT @SeatingId,
										 @BranchId,
										 @EmployeeId,
										 @SeatCode,
										 @Description,
										 @Comment,
										 @Currentdate,
										 @OperationsPerformedBy,
										 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

							   END
							   ELSE
							   BEGIN
									
									UPDATE [dbo].[SeatingArrangement]
									    SET [BranchId] = @BranchId
										    ,[EmployeeId] = @EmployeeId
											,[SeatCode] = @SeatCode
											,[Description] = @Description
											,[Comment] = @Comment
											,[UpdatedByUserId] = @OperationsPerformedBy
											,[UpdatedDateTime] = @Currentdate
											,[InactiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
										WHERE Id = @SeatingId

							   END  
							       
			                 SELECT Id FROM [dbo].[SeatingArrangement] WHERE Id = @SeatingId
			                       
			           END
			           ELSE
			         
			           	RAISERROR (50008,11, 1)
			         
			         END
			         ELSE
			         BEGIN
			         
			         		RAISERROR (@HavePermission,11, 1)
			         		
			         END
           END
		END

		END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO