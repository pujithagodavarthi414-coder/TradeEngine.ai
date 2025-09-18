using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class StoreModelConverter
    {
        public static StoreCollectionModel ConvertStoreUpsertInputModelToCollectionModel(StoreInputModel inputModel)
        {
            return new StoreCollectionModel
            {
                Id = inputModel.StoreId ?? Guid.NewGuid(),
                StoreName = inputModel.StoreName,
               StoreSize = inputModel.StoreSize,
               CompanyId = inputModel.CompanyId,
               IsDefault = inputModel.IsDefault,
               IsArchived = false,
               IsCompany = inputModel.IsCompany
            };
        }

    }
}
