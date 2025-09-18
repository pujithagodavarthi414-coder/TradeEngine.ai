CREATE PROCEDURE USP_UpsertProfessionalTaxRange
(
 @Id uniqueidentifier,
 @FromRange DECIMAL(18,4),
 @ToRange DECIMAL(18,4),
 @TaxAmount DECIMAL(18,4),
 @IsArchived bit,
 @BranchId uniqueidentifier = NULL,
 @ActiveFrom DATETIME = NULL,
 @ActiveTo DATETIME = NULL
)
AS
BEGIN

IF(@BranchId IS NULL)
BEGIN

RAISERROR(50011,16, 2, 'Branch')

END
ELSE IF(@ActiveFrom IS NULL)
BEGIN

RAISERROR(50011,16, 2, 'ActiveFrom')

END
ELSE
BEGIN

DECLARE @ProfessionalTaxRangeCount INT = 0

IF(@ActiveTo IS NULL)
BEGIN

	SET @ProfessionalTaxRangeCount = (SELECT COUNT(1) FROM ProfessionalTaxRange WHERE BranchId = @BranchId AND (Id <> @Id OR @Id IS NULL) 
	                                                                            AND ((FromRange = @FromRange) 
                                                                                     OR (ToRange = @ToRange)
                                                                                     OR (ToRange = @FromRange)
																					 OR (FromRange = @ToRange)
                                                                                     OR (FromRange > @FromRange AND FromRange < @ToRange)
                                                                                     OR (FromRange < @FromRange AND ToRange > @FromRange)
                                                                                     OR (FromRange < @ToRange AND ToRange > @ToRange))
																				AND ((@ActiveFrom <= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)
																				OR (@ActiveFrom >= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)))
END
IF(@ActiveTo IS NOT NULL)
BEGIN

	SET @ProfessionalTaxRangeCount = (SELECT COUNT(1) FROM ProfessionalTaxRange WHERE BranchId = @BranchId AND (Id <> @Id OR @Id IS NULL) 
																			       AND ((FromRange = @FromRange) 
                                                                                     OR (ToRange = @ToRange)
                                                                                     OR (ToRange = @FromRange)
																					 OR (FromRange = @ToRange)
                                                                                     OR (FromRange > @FromRange AND FromRange < @ToRange)
                                                                                     OR (FromRange < @FromRange AND ToRange > @FromRange)
                                                                                     OR (FromRange < @ToRange AND ToRange > @ToRange))
																				AND((@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom AND @ActiveFrom <= ActiveTo)))))

END

IF(@ProfessionalTaxRangeCount > 0)
BEGIN
     RAISERROR('ProfessionalTaxRangeActiveFromOrActiveToDateMatchesWithOtherActiveFromOrActiveToDate',16, 1)
END
ELSE
BEGIN

IF(@Id is null)
BEGIN
INSERT INTO ProfessionalTaxRange(Id, FromRange, ToRange,TaxAmount, IsArchived,BranchId,ActiveFrom,ActiveTo) VALUES(NEWID(), @FromRange, @ToRange, @TaxAmount, @IsArchived,@BranchId,@ActiveFrom,@ActiveTo)
END
ELSE
BEGIN
if(@IsArchived = 0)
BEGIN
UPDATE ProfessionalTaxRange SET FromRange = @FromRange, ToRange = @ToRange, TaxAmount = @TaxAmount,BranchId = @BranchId, IsArchived = @IsArchived,[ActiveFrom] = @ActiveFrom,[ActiveTo]  = @ActiveTo WHERE Id = @Id
END
ELSE
BEGIN
UPDATE ProfessionalTaxRange SET FromRange = @FromRange, ToRange = @ToRange, TaxAmount = @TaxAmount, IsArchived = @IsArchived,BranchId = @BranchId,[ActiveFrom] = @ActiveFrom,[ActiveTo]  = @ActiveTo WHERE Id = @Id
END
END
END
END
END