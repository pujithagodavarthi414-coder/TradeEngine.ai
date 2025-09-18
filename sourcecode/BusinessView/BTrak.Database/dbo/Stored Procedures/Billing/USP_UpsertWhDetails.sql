CREATE PROCEDURE [dbo].[USP_UpsertWhDetails]
(
   @LeadId UNIQUEIDENTIFIER = NULL,
   @WeighingSlipDate DATETIME,

   @UserId UNIQUEIDENTIFIER = NULL,
   @FinalNetWeightApprox Float = NULL,

   @FinalQuantityInMT Float,
   @FinalVehicleNumberOfTransporter NVARCHAR(250)  = NULL,
   @FinalMobileNumberOfTruckDriver NVARCHAR(250)  = NULL,
   @FinalPortId UNIQUEIDENTIFIER,
   @FinalDrums Int,
   @FinalBLNumber NVARCHAR(250),
   @WeighingSlipNumber NVARCHAR(250),
   @WeighingSlipPhoto NVARCHAR(MAX),
   @UploadedOther NVARCHAR(MAX)
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		
			DECLARE @HavePermission NVARCHAR(250)  =  '1'
			IF (@HavePermission = '1')
			BEGIN
	

				    UPDATE [LeadContactSubmissions]
					  SET  WeighingSlipDate = @WeighingSlipDate,
						   FinalQuantityInMT = @FinalQuantityInMT,
						   FinalVehicleNumberOfTransporter = @FinalVehicleNumberOfTransporter,
						   FinalPortId = @FinalPortId,
						   FinalDrums = @FinalDrums,
						   FinalBLNumber = @FinalBLNumber,
						   WeighingSlipNumber = @WeighingSlipNumber,
						   WeighingSlipPhoto = @WeighingSlipPhoto,
						   UploadedOther = @UploadedOther,
						   WhUpdatedUserId = @UserId,
						   WhUpdatedDateTime = GetDate()
						  WHERE Id = @LeadId
						                  
					END

			        SELECT Id FROM [dbo].[LeadContactSubmissions] WHERE Id = @LeadId

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO