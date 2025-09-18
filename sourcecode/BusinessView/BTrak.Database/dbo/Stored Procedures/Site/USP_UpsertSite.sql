CREATE PROCEDURE [dbo].[USP_UpsertSite]
	@Id UNIQUEIDENTIFIER,
	@Name NVARCHAR(800),
	@Email NVARCHAR(800),
	@Address NVARCHAR(MAX),
	@Addressee NVARCHAR(MAX),
	@IsArchived BIT=NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
    @TimeStamp TIMESTAMP = NULL,
	@AutoCTariff DECIMAL(18,2) = NULL,
	@RoofRentalAddress NVARCHAR(800),
	@Date DATETIME,
	@ParcellNo NVARCHAR(800),
	@M2 DECIMAL(18,2),
	@Chf DECIMAL(18,2),
	@Term INT,
	@Muncipallity NVARCHAR(800),
	@Canton NVARCHAR(800),
	@StartingYear DATETIME = NULL,
	@AnnualReduction DECIMAL(18,2) = NULL,
	@RepriceExpected DECIMAL(18,2) = NULL,
	@AutoCExpected DECIMAL(18,2) = NULL,
	@ProductionFirstYear INT = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	   DECLARE @HavePermission NVARCHAR(250)  = '1'
	   IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	   IF(@Id = '00000000-0000-0000-0000-000000000000') SET @Id = NULL
		IF(@Name = '' ) SET @Name = NULL
		IF(@Email = '' ) SET @Email = NULL
		IF(@Name IS NULL)
		BEGIN
			RAISERROR(50011,16,2,'SiteName')
		END
		ELSE IF(@Email IS NULL)
		BEGIN
			RAISERROR(50011,16,2,'Email')
		END
		ELSE IF (@HavePermission = '1')
        BEGIN
		DECLARE @CompanyId UNIQUEIDENTIFIER =    (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
		   DECLARE @Currentdate DATETIME = GETDATE()
		  DECLARE @IsLatest BIT = (CASE WHEN @Id IS NULL THEN 1 ELSE 
                                 CASE WHEN (SELECT [TimeStamp] FROM [site] WHERE Id = @Id) = @TimeStamp THEN 1 ELSE 0 END END)
		 DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
		DECLARE @SitesCount INT = (SELECT COUNT(1) FROM [site] WHERE [Name] = @Name AND (@Id IS NULL OR Id <> @Id) AND CompanyId = @CompanyId) 
		IF (@SitesCount IS NULL)
			BEGIN
				
				RAISERROR(50001,16,1,'Sites')

			END 
			ELSE  IF(EXISTS(SELECT Id FROM [CreditNotes] WHERE SiteId = @Id AND InActiveDateTime IS NULL) AND @IsArchived = 1 AND @Id IS NOT NULL)
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisSiteIsHavingDependencieshPleaseDeleteTheDependenciesAndTryAgain'
         
         END
		 ELSE  IF(EXISTS(SELECT Id FROM [ExpenseBooking] WHERE SiteId = @Id AND InActiveDateTime IS NULL AND @IsArchived = 1 AND @Id IS NOT NULL))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisSiteIsHavingDependencieshPleaseDeleteTheDependenciesAndTryAgain'
         
         END
		 ELSE  IF(EXISTS(SELECT Id FROM [PaymentReceipt] WHERE SiteId = @Id AND InActiveDateTime IS NULL AND @IsArchived = 1 AND @Id IS NOT NULL))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisSiteIsHavingDependencieshPleaseDeleteTheDependenciesAndTryAgain'
         
         END
		 ELSE  IF(EXISTS(SELECT Id FROM [GrERomande] WHERE SiteId = @Id AND InActiveDateTime IS NULL AND @IsArchived = 1 AND @Id IS NOT NULL))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisSiteIsHavingDependencieshPleaseDeleteTheDependenciesAndTryAgain'
         
         END
         
         IF(@IsEligibleToArchive <> '1')
         BEGIN
         
             RAISERROR (@isEligibleToArchive,11, 1)
         
         END
		ELSE IF(@IsLatest=1)
		BEGIN
		   

		   IF(@Id IS NULL)
		    BEGIN
			     
				SET @Id = NEWID()
			  INSERT INTO [site](
			                           Id,
			                           CompanyId,
			                           [Name],
			                           [Email],
			                           [Address],
			                           [Addressee],
			                           CreatedDateTime,
			                           CreatedByUserId,
									   InActiveDateTime,
									   AutoCTariff,
									   [RoofRentalAddress],
									   [Date],
									   [ParcellNo],
									   [M2],
									   [Chf],
									   [Term],
									   [Muncipallity],
									   [Canton],
									   StartingYear,
									   ProductionFirstYear,
									   AutoCExpected,
									   AnnualReduction,
									   RepriceExpected
									   )
								SELECT @Id,
								       @CompanyId,
									   @Name,
									   @Email,
									   @Address,
									   @Addressee,
									   @CurrentDate,
									   @OperationsPerformedBy,
									   CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
									   @AutoCTariff,
									   @RoofRentalAddress,
									   @Date,
									   @ParcellNo,
									   @M2,
									   @Chf,
									   @Term,
									   @Muncipallity,
									   @Canton,
									   @StartingYear,
									   @ProductionFirstYear,
									   @AutoCExpected,
									   @AnnualReduction,
									   @RepriceExpected
			END
			ELSE
			 BEGIN
			 UPDATE [site]
			SET CompanyId			   = 		 @CompanyId,
				[Name]				   = 		 @Name,
				[Address]			   = 		 @Address,
				[Addressee]			   = 		 @Addressee,
				[Email]				   = 		 @Email,
			    CreatedDateTime		   = 		 @CurrentDate,
			    CreatedByUserId		   = 		 @OperationsPerformedBy,
				InActiveDateTime	   = 		 CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
				AutoCTariff            =         @AutoCTariff,
				[RoofRentalAddress]		=		@RoofRentalAddress,
				[Date]					=		@Date,
				[ParcellNo]				=		@ParcellNo,
				[M2]					=		@M2,
				[Chf]					=		@Chf,
				[Term]					=		@Term,
				[Muncipallity]			=		@Muncipallity,
				[Canton]				=		@Canton,
				StartingYear			=		@StartingYear,
				ProductionFirstYear		=		@ProductionFirstYear,
				AutoCExpected			=		@AutoCExpected,
				AnnualReduction			=		@AnnualReduction,
				RepriceExpected			=		@RepriceExpected
			WHERE Id = @Id
			 
			 END
			 SELECT @Id
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