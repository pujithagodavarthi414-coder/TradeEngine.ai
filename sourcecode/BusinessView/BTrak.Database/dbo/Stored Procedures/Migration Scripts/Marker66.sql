CREATE PROCEDURE [dbo].[Marker66]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

	UPDATE CustomWidgets SET WidgetQuery='SELECT StatusCount ,StatusCounts
	                          from
							  (SELECT CAST((T.[Damaged assets]/(CASE WHEN [Total assets] = 0 THEN 1 ELSE [Total assets] END *1.0))*100 AS decimal(10,2)) [Damaged assets],
	       CAST(([Unassigned assets]/(CASE WHEN [Total assets] = 0 THEN 1 ELSE [Total assets] END*1.0))*100 AS decimal(10,2)) [Unassigned assets],
		   CAST(([Assigned assets]/(CASE WHEN [Total assets] = 0 THEN 1 ELSE [Total assets] END*1.0))*100 AS decimal(10,2)) [Assigned assets] 
	   FROM(SELECT COUNT(CASE WHEN A.IsWriteOff = 1 THEN 1 END )[Damaged assets]
	   ,COUNT(CASE WHEN AE.AssetId IS NULL AND (A.IsWriteOff = 0 OR A.IsWriteOff IS NULL) AND A.IsEmpty = 1 THEN 1 END )[Unassigned assets],
	    COUNT(CASE WHEN AE.AssetId IS NOT NULL AND (A.IsWriteOff = 0 OR A.IsWriteOff IS NULL) THEN 1 END )[Assigned assets],
		COUNT(1) [Total assets]
			 FROM Asset A INNER JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId AND PD.InactiveDateTime IS NULL 
						  INNER JOIN Supplier S ON S.Id = PD.SupplierId AND S.InactiveDateTime IS NULL
			              LEFT JOIN AssetAssignedToEmployee AE ON AE.AssetId = A.Id AND AE.AssignedDateTo IS NULL
	                   WHERE S.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
						   )T
	                            
								) as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN ([Damaged assets],[Unassigned assets],[Assigned assets]) 
	                                    )p' 
	WHERE CustomWidgetName = 'Assigned, UnAssigned, Damaged Assets %' AND CompanyId = @CompanyId
	
END
GO