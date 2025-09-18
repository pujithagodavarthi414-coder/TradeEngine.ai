-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-05-20 00:00:00.000'
-- Purpose      To Save or update the EmployeeGrade
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertEmployeeGrade] @OperationsPerformedBy='2C0641B3-707F-4B67-B82B-AC4532A0E590',
--@EmployeeId = '2DBB338F-BAC1-42DD-AE42-232DEE62682D',@GradeId = 'DDDBCE23-8C30-4A94-A52F-B79FD27DF125',@ActiveFrom = '2017-02-02',@ActiveTo = '2018-02-02'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmployeeGrade]
(
   @EmployeeGradeId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER  = NULL,
   @GradeId UNIQUEIDENTIFIER  = NULL,
   @ActiveFrom DATETIME = NULL,
   @ActiveTo DATETIME = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	    
		IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL
	    
		IF(@GradeId = '00000000-0000-0000-0000-000000000000') SET @GradeId = NULL
	    
		IF(@EmployeeGradeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeGradeId = NULL

	    IF(@GradeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'GradeName')

		END
		ELSE IF(@EmployeeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Employee')

		END
		ELSE IF(@ActiveFrom IS NULL)
		BEGIN
			
			RAISERROR(50011,16, 2, 'ActiveFrom')

		END
		ELSE
		BEGIN
		
		DECLARE @Currentdate DATETIME = GETDATE()

		IF(@ActiveTo IS NULL)
		BEGIN

			DECLARE @EmployeeActiveToNullRecordsCount INT

			SET @EmployeeActiveToNullRecordsCount = (SELECT COUNT(1)
			                                         FROM EmployeeGrade 
													 WHERE EmployeeId = @EmployeeId
			                                               AND [InActiveDateTime] IS NULL
														   AND ActiveTo IS NULL)
			IF(@EmployeeActiveToNullRecordsCount > 0)
			BEGIN

				RAISERROR('ALREADYHAVINGACTIVETONULLRECORDSPLEASEUPDATETHOSERECORDSANDTRYAGAIN',11, 1)

			END
		END


		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @EmployeeGradeIdCount INT = (SELECT COUNT(1) FROM EmployeeGrade WHERE Id = @EmployeeGradeId)

		IF(@EmployeeGradeIdCount = 0 AND @EmployeeGradeId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'EmployeeGrade')
		END
		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @EmployeeGradeId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM EmployeeGrade WHERE Id = @EmployeeGradeId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

			        
			      IF(@EmployeeGradeId IS NULL)
				  BEGIN

				  SET @EmployeeGradeId = NEWID()

			        INSERT INTO [dbo].[EmployeeGrade](
			                    [Id],
			                    [EmployeeId],
								[GradeId],
								[ActiveFrom],
								[ActiveTo],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId])
			             SELECT @EmployeeGradeId,
			                    @EmployeeId,
								@GradeId,
								@ActiveFrom,
								@ActiveTo,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy
			       
				   END
				   ELSE
				   BEGIN

				    UPDATE [EmployeeGrade]
					  SET  EmployeeId = @EmployeeId,
					       GradeId  = @GradeId,
						   [ActiveFrom] = @ActiveFrom,
						   [ActiveTo] = @ActiveTo,
					       InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime  = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @EmployeeGradeId

				   END

			        SELECT Id FROM [dbo].[EmployeeGrade] WHERE Id = @EmployeeGradeId

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