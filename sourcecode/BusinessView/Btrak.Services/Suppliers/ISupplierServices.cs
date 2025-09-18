using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Supplier;
using BTrak.Common;

namespace Btrak.Services.Suppliers
{
    public interface ISupplierServices
    {
        Guid? UpsertSupplier(SupplierDetailsInputModel supplierInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SupplierDetailsOutputModel> SearchSupplier(SupplierSearchCriteriaInputModel suppliersSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SupplierDetailsOutputModel> GetSupplierById(Guid? supplierId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SupplierDetailsOutputModel> GetAllSuppliers(string searchText,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<SuppliersDropDownOutputModel> GetSupplierDropDown(string searchText, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
    }
}
