-------------------------------------------------------------------------------
-- Author       Sushmitha Kandapu
-- Created      '2020-01-06 00:00:00.000'
-- Purpose      To Save or Update Booking
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertBookingDetails] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
-- @BranchName = 'Test1'				  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertBookingDetails]
(
   @BookingId UNIQUEIDENTIFIER = NULL,
   @RoomId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @RoomAmitites  NVARCHAR(50) = NULL,
   @VenueAmitites  NVARCHAR(50) = NULL,
   @Tax DECIMAL (15,3) = NULL,
   @PaidAmount  DECIMAL (15,3) = NULL,
   @ActualExpensesAmount  DECIMAL (15,3) = NULL,
   @DamagesAmount  DECIMAL (15,3) = NULL,
   @RefundedAmount  DECIMAL (15,3) = NULL,
   @DateFrom DATETIME = NULL,
   @DateTo DATETIME = NULL,
   @CanceledDate DATETIME = NULL,
   @EventTypeId UNIQUEIDENTIFIER = NULL,
   @FromTime nvarchar(20) = NULL,
   @Totime nvarchar(20)  = NULL,
   @IsMultiple BIT = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
		
		BEGIN
			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			IF(@BookingId = '00000000-0000-0000-0000-000000000000') SET @BookingId = NULL
			IF(@DateTo IS NULL) SET @DateTo = @DateFrom
			DECLARE @BookingIdCount INT = (SELECT COUNT(1) FROM Booking WHERE RoomId = @RoomId AND (BookingFrom = @DateFrom AND BookingTo = @DateTo) AND (FromTime =@FromTime AND ToTime =@Totime))
			IF(@BookingIdCount = 1)
			BEGIN
			    RAISERROR(50011,16, 2,'Room')
			END
			 ELSE
			  BEGIN
			     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				 IF (@HavePermission = '1')
				 BEGIN
				 	DECLARE @IsLatest BIT = (CASE WHEN @BookingId  IS NULL
				 	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
				                                                            FROM [Booking] WHERE Id = @BookingId ) = @TimeStamp
				 													THEN 1 ELSE 0 END END)
					 IF(@IsLatest = 1)
					 BEGIN
					 	 
					      DECLARE @Currentdate DATETIME = GETDATE()
						
						IF(@BookingId IS NULL)
						BEGIN

						SET @BookingId = NEWID()
						INSERT INTO [dbo].[Booking](
						             [Id],
									 [RoomId],
									 [RoomAmenityId],
									 [VenueAmenityId],
									 [Tax],
									 [ActualExpensesAmount],
									 [BookingFrom],
									 [BookingTo],
									 [CanceledDateTime],
									 [EventTypeId],
									 [PaidAmount],
									 [DamagesAmount],
									 [RefundedAmount],
									 [FromTime],
									 [ToTime],
									 [IsMultiple],
									 [InActiveDateTime],
									 [CreatedDateTime],
									 [CreatedByUserId]					
									 )
						      SELECT @BookingId,
									 @RoomId,
									 ISNULL(@RoomAmitites,NULL),
									 ISNULL(@VenueAmitites,NULL),
									 ISNULL(@Tax,0),
									 ISNULL(@ActualExpensesAmount,0),
									 @DateFrom,
									 @DateTo,
									 CASE WHEN @CanceledDate IS NULL THEN NULL ELSE GETDATE() END,
									 ISNULL(@EventTypeId,NULL),
									 ISNULL(@PaidAmount,0),
									 ISNULL(@DamagesAmount,0),
									 ISNULL(@RefundedAmount,0),
									 ISNULL(cast(@FromTime as time),NULL),
									 ISNULL(cast(@Totime as time),NULL),
									 @IsMultiple,
									 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
									 @Currentdate,
									 @OperationsPerformedBy
									 
						END
						ELSE
						BEGIN

							UPDATE [dbo].[Booking]
								SET [RoomId]				=    @RoomId,
									[RoomAmenityId]			=    @RoomAmitites,
									[VenueAmenityId]		=    @VenueAmitites,
									[Tax]					=    @Tax,
									[ActualExpensesAmount]  =    @ActualExpensesAmount,
									[BookingFrom]			=	 @DateFrom,
									[BookingTo]				=	 @DateTo,
									[CanceledDateTime]	    =    @CanceledDate,
									[EventTypeId]  = @EventTypeId,
									[InActiveDateTime]		=   CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
									[PaidAmount]			=   @PaidAmount,
									[UpdatedDateTime]		=   @Currentdate,
									[DamagesAmount]			=	@DamagesAmount,
									[UpdatedByUserId]		=   @OperationsPerformedBy,
									[RefundedAmount]		=	@RefundedAmount,
									[FromTime]				=	@FromTime,
									[ToTime]				=	@Totime,
									[IsMultiple]			=	@IsMultiple
								WHERE Id = @BookingId		
											
						END			
						             SELECT Id FROM [dbo].[Booking] WHERE Id = @BookingId
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

