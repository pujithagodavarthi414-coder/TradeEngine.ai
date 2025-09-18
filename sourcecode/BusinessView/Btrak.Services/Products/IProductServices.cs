using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Products;
using BTrak.Common;

namespace Btrak.Services.Products
{
    public interface IProductServices
    {
        Guid? UpsertProduct(ProductInputModel productModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertProductDetails(ProductDetailsInputModel productDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProductOutputModel> SearchProduct(ProductSearchCriteriaInputModel productSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ProductDetailsOutputModel GetProductDetailsById(Guid? productId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProductDetailsOutputModel> GetAllProductDetails(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProductOutputModel> GetAllProducts(ProductSearchCriteriaInputModel productSearchCriteriaInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProductDetailsOutputModel> SearchProductDetails(ProductDetailsSearchCriteriaInputModel productDetailsSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ProductOutputModel GetProductById(Guid? productId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
