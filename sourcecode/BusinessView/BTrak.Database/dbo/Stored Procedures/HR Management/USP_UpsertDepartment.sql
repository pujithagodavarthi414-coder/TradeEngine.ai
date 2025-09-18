-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or Update Department
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertDepartment] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@DepartmentName = 'Test'								  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertDepartment]
(
   @DepartmentId UNIQUEIDENTIFIER = NULL,
   @DepartmentName NVARCHAR(50) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER ,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		IF(@IsArchived = 1 AND @DepartmentId IS NOT NULL)
		BEGIN
		     DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	         IF(EXISTS(SELECT Id FROM Job WHERE DepartmentId = @DepartmentId))
	         BEGIN
	         SET @IsEligibleToArchive = 'ThisDepartmentUsedInJobPleaseDeleteTheDependenciesAndTryAgain'
	         END
		     IF(@IsEligibleToArchive <> '1')
		     BEGIN
		         RAISERROR (@isEligibleToArchive,11, 1)
		     END
	    END
		IF(@DepartmentName = '') SET @DepartmentName = NULL
	    IF(@DepartmentName IS NULL)
		BEGIN
		    RAISERROR(50011,16, 2, 'DepartmentName')
		END
		ELSE
		BEGIN
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		DECLARE @DepartmentIdCount INT = (SELECT COUNT(1) FROM Department  WHERE Id = @DepartmentId)
		DECLARE @DepartmentNameCount INT = (SELECT COUNT(1) FROM Department WHERE DepartmentName = @DepartmentName AND CompanyId = @CompanyId AND (@DepartmentId IS NULL OR Id <> @DepartmentId))
	    IF(@DepartmentIdCount = 0 AND @DepartmentId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 2,'Department')
        END
        ELSE IF(@DepartmentNameCount>0)
        BEGIN
          RAISERROR(50001,16,1,'Department')
         END
         ELSE
		  BEGIN
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			         IF (@HavePermission = '1')
			         BEGIN
			         	DECLARE @IsLatest BIT = (CASE WHEN @DepartmentId  IS NULL
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [Department] WHERE Id = @DepartmentId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			            IF(@IsLatest = 1)
			         	BEGIN
			                 DECLARE @Currentdate DATETIME = GETDATE()
             
			 IF( @DepartmentId IS NULL)
			 BEGIN

			 SET @DepartmentId = NEWID()
			 INSERT INTO [dbo].[Department](
                         [Id],
						 [CompanyId],
						 [DepartmentName],
						 [InActiveDateTime],
						 [CreatedDateTime],
						 [CreatedByUserId]
						 )
                  SELECT @DepartmentId,
						 @CompanyId,
						 @DepartmentName,
						 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
						 @Currentdate,
						 @OperationsPerformedBy

			END
			ELSE
			BEGIN

				UPDATE [dbo].[Department]
					SET  [CompanyId]			   =  		 @CompanyId,
						 [DepartmentName]		   =  		 @DepartmentName,
						 [InActiveDateTime]		   =  		 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
						 [UpdatedDateTime]		   =  		 @Currentdate,
						 [UpdatedByUserId]		   =  		 @OperationsPerformedBy
					WHERE Id = @DepartmentId

			END


			             SELECT Id FROM [dbo].[Department] WHERE Id = @DepartmentId
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
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO