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
    public partial class ProductRepository
    {
        public Guid? UpsertProduct(ProductInputModel product, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProductId", product.ProductId);
                    vParams.Add("@ProductName", product.ProductName);
                    vParams.Add("@IsArchived", product.IsArchived);
                    vParams.Add("@TimeStamp", product.TimeStamp,DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertProduct, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProduct", "ProductRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionProductUpsert);
                return null;
            }
        }

        public List<ProductOutputModel> SearchProducts(ProductSearchCriteriaInputModel productSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Pagesize", productSearchCriteriaInputModel.PageSize);
                    vParams.Add("@ProductId", productSearchCriteriaInputModel.ProductId);
                    vParams.Add("@ProductName", productSearchCriteriaInputModel.SearchText);
                    vParams.Add("@Pagenumber", productSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProductOutputModel>(StoredProcedureConstants.SpSearchProduct, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchProducts", "ProductRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchProducts);
                return new List<ProductOutputModel>();
            }
        }

        public ProductOutputModel GetProductById(Guid? productId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProductId", productId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProductOutputModel>(StoredProcedureConstants.SpGetProductsById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProductById", "ProductRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetProductById);
                return null;
            }
        }

        public List<ProductOutputModel> GetAllProducts(ProductSearchCriteriaInputModel productSearchCriteriaInputModel, Guid loggedInGuid, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInGuid);
                    vParams.Add("@PageNumber", productSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", productSearchCriteriaInputModel.PageSize);
                    vParams.Add("@SortBy", productSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", productSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@SearchText", productSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", productSearchCriteriaInputModel.IsArchived);
                    return vConn.Query<ProductOutputModel>(StoredProcedureConstants.SpGetAllProducts, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllProducts", "ProductRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllProducts);
                return null;
            }
        }
    }
}
