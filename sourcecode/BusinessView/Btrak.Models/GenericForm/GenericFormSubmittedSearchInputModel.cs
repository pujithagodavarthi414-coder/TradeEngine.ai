using Btrak.Models.FormDataServices;
using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;

namespace Btrak.Models.GenericForm
{
    public class GenericFormSubmittedSearchInputModel
    {
        public Guid? GenericFormSubmittedId { get; set; }
        public Guid? FormId { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? UserId { get; set; }
        public bool? IsArchived { get; set; }
        public string Key { get; set; }
        public string QuerytoFilter { get; set; }
        public string FormName { get; set; }
        public string CustomApplicationName { get; set; }
        public int? PageNumber { get; set; }
        public int? PageSize { get; set; }
        public bool? IsPagingRequired { get; set; }
        public bool? IsLatest { get; set; }
        public List<ParamsKeyModel> ParamsKeyModel { get; set; }
        public string DateFrom { get; set; }
        public string DateTo { get; set; }
        public string CompanyIds { get; set; }
        public bool? FilterFieldsBasedOnForm { get; set; }
        public string FilterFormName { get; set; }
        public bool AdvancedFilter { get; set; }
        public List<FieldSearchModel> Filters { get; set; }
        public string KeyFilterJson { get; set; }
        public string FilterValue { get; set; }
        public string Value { get; set; }
        public bool IsRecordLevelPermissionEnabled { get; set; }
        public string Message { get; set; }
        public string Subject { get; set; }
        public List<Guid> UserIds { get; set; }
        public int? ConditionalEnum { get; set; }
        public string ConditionsJson { get; set; }
        public string RoleIds { get; set; }
    }

    public enum ConditionalEnum
    {
        UserBased,
        RoleBased,
        ConditionBased
    }

    public class FieldSearchModel
    {
        public string Field { get; set; }
        public string Operator { get; set; }
        public string Value { get; set; }
    }

    public class UniqueValidateModel
    {
        public string DataJson { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? FormId { get; set; }
        public Guid? GenericFormSubmittedId { get; set; }
    }
}

