using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Products;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ProductDetailRepository
    {
        public Guid? UpsertProductDetails(ProductDetailsInputModel productDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProductDetailsId", productDetails.ProductDetailsId);
                    vParams.Add("@ProductId", productDetails.ProductId);
                    vParams.Add("@SupplierId", productDetails.SupplierId);
                    vParams.Add("@ProductCode", productDetails.ProductCode);
                    vParams.Add("@ManufacturerCode", productDetails.ManufacturerCode);
                    vParams.Add("@IsArchived", productDetails.IsArchived);
                    vParams.Add("@TimeStamp", productDetails.TimeStamp,DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertProductDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProductDetails", "ProductDetailRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionProductDetail);
                return null;
            }
        }

        public ProductDetailsOutputModel GetProductDetailsById(Guid? productDetailsId, Guid operationPerformedBy, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProductDetailsId", productDetailsId);
                    vParams.Add("@OperationsPerformedBy", operationPerformedBy);
                    return vConn.Query<ProductDetailsOutputModel>(StoredProcedureConstants.SpGetProductDetailsById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProductDetailsById", "ProductDetailRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionProductDetailsById);
                return null;
            }
        }

        public List<ProductDetailsOutputModel> GetAllProductDetails(Guid operationPerformedBy, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", operationPerformedBy);
                    return vConn.Query<ProductDetailsOutputModel>(StoredProcedureConstants.SpGetAllProductDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllProductDetails", "ProductDetailRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllProductDetails);
                return new List<ProductDetailsOutputModel>();
            }
        }

        public List<ProductDetailsOutputModel> SearchProductDetails(ProductDetailsSearchCriteriaInputModel productDetailsSearchModel, Guid operationPerformedBy, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SortBy", productDetailsSearchModel.SortBy);
                    vParams.Add("@SortDirection", productDetailsSearchModel.SortDirection);
                    vParams.Add("@SearchText", productDetailsSearchModel.SearchText);
                    vParams.Add("@PageSize", productDetailsSearchModel.PageSize);
                    vParams.Add("@PageNumber", productDetailsSearchModel.PageNumber);
                    vParams.Add("@IsArchived", productDetailsSearchModel.IsArchived);
                    vParams.Add("@ProductDetailsId", productDetailsSearchModel.ProductDetailsId);
                    vParams.Add("@ProductId", productDetailsSearchModel.ProductId);
                    vParams.Add("@SupplierId", productDetailsSearchModel.SupplierId);
                    vParams.Add("@SearchProductCode", productDetailsSearchModel.SearchProductCode);
                    vParams.Add("@SearchManufacturerCode", productDetailsSearchModel.SearchManufacturerCode);
                    vParams.Add("@OperationsPerformedBy", operationPerformedBy);
                    return vConn.Query<ProductDetailsOutputModel>(StoredProcedureConstants.SpSearchProductDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchProductDetails", "ProductDetailRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchProductDetails);
                return new List<ProductDetailsOutputModel>();
            }
        }
    }
}
