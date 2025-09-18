using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.MasterData;
using Btrak.Services.Audit;
using Btrak.Services.Helpers.MasterDataValidationHelper;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.MasterData
{
    public class AccessibleIpAddressService : IAccessibleIpAddressService
    {
        private readonly AccessibleIpAddressesRepository _accessibleIpAddressesRepository;
        private readonly IAuditService _auditService;

        public AccessibleIpAddressService(AccessibleIpAddressesRepository accessibleIpAddressesRepository, IAuditService auditService)
        {
            _accessibleIpAddressesRepository = accessibleIpAddressesRepository;
            _auditService = auditService;
        }
        public Guid? UpsertAccessibleIpAddresses(AccessibleIpAddressUpsertModel accessibleIpAddressUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {   
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert accessible ip address", "accessibleIpAddressUpsertModel", accessibleIpAddressUpsertModel, "accessible ip address Api"));

            if (!AccessibleIpAddressDataValidation.UpsertAccessibleIpAddressNameValidation(accessibleIpAddressUpsertModel, loggedInContext, validationMessages))
            {
                return null;
            }

            accessibleIpAddressUpsertModel.IpAddressId = _accessibleIpAddressesRepository.UpsertAccessibleIpAdresses(accessibleIpAddressUpsertModel, loggedInContext, validationMessages);

            LoggingManager.Debug("accessible ip address with the id " + accessibleIpAddressUpsertModel.IpAddressId);

            _auditService.SaveAudit(AppCommandConstants.UpsertAccessibleIpAddressesCommandId, accessibleIpAddressUpsertModel, loggedInContext);

            return accessibleIpAddressUpsertModel.IpAddressId;
        }
    }
}
