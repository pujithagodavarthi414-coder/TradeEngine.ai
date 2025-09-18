using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ContractTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ContractType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ContractTypeDbEntity aContractType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aContractType.Id);
					 vParams.Add("@CompanyId",aContractType.CompanyId);
					 vParams.Add("@ContractTypeName",aContractType.ContractTypeName);
					 vParams.Add("@IsActive",aContractType.IsActive);
					 vParams.Add("@CreatedDateTime",aContractType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aContractType.CreatedByUserId);
					 vParams.Add("@OriginalId",aContractType.OriginalId);
					 vParams.Add("@VersionNumber",aContractType.VersionNumber);
					 vParams.Add("@InActiveDateTime",aContractType.InActiveDateTime);
					 vParams.Add("@TimeStamp",aContractType.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aContractType.AsAtInactiveDateTime);
					 vParams.Add("@TerminationDate",aContractType.TerminationDate);
					 vParams.Add("@TerminationReason",aContractType.TerminationReason);
					 int iResult = vConn.Execute("USP_ContractTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ContractType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ContractTypeDbEntity aContractType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aContractType.Id);
					 vParams.Add("@CompanyId",aContractType.CompanyId);
					 vParams.Add("@ContractTypeName",aContractType.ContractTypeName);
					 vParams.Add("@IsActive",aContractType.IsActive);
					 vParams.Add("@CreatedDateTime",aContractType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aContractType.CreatedByUserId);
					 vParams.Add("@OriginalId",aContractType.OriginalId);
					 vParams.Add("@VersionNumber",aContractType.VersionNumber);
					 vParams.Add("@InActiveDateTime",aContractType.InActiveDateTime);
					 vParams.Add("@TimeStamp",aContractType.TimeStamp);
					 vParams.Add("@AsAtInactiveDateTime",aContractType.AsAtInactiveDateTime);
					 vParams.Add("@TerminationDate",aContractType.TerminationDate);
					 vParams.Add("@TerminationReason",aContractType.TerminationReason);
					 int iResult = vConn.Execute("USP_ContractTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ContractType table.
		/// </summary>
		public ContractTypeDbEntity GetContractType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ContractTypeDbEntity>("USP_ContractTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ContractType table.
		/// </summary>
		 public IEnumerable<ContractTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ContractTypeDbEntity>("USP_ContractTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ContractType table by a foreign key.
		/// </summary>
		public List<ContractTypeDbEntity> SelectAllByOriginalId(Guid? originalId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@OriginalId",originalId);
				 return vConn.Query<ContractTypeDbEntity>("USP_ContractTypeSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
