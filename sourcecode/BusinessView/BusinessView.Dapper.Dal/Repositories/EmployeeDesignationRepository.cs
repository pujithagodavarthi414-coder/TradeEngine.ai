using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeDesignationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeDesignation table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeDesignationDbEntity aEmployeeDesignation)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeDesignation.Id);
					 vParams.Add("@DesignationId",aEmployeeDesignation.DesignationId);
					 vParams.Add("@EmployeeId",aEmployeeDesignation.EmployeeId);
					 vParams.Add("@EmploymentStatusId",aEmployeeDesignation.EmploymentStatusId);
					 vParams.Add("@JobCategoryId",aEmployeeDesignation.JobCategoryId);
					 vParams.Add("@DepartmentId",aEmployeeDesignation.DepartmentId);
					 vParams.Add("@ContrcatStartDate",aEmployeeDesignation.ContrcatStartDate);
					 vParams.Add("@ContrcatEndDate",aEmployeeDesignation.ContrcatEndDate);
					 vParams.Add("@ContractDetails",aEmployeeDesignation.ContractDetails);
					 vParams.Add("@ActiveFrom",aEmployeeDesignation.ActiveFrom);
					 vParams.Add("@ActiveTo",aEmployeeDesignation.ActiveTo);
					 vParams.Add("@CreatedDateTime",aEmployeeDesignation.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeDesignation.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeDesignation.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeDesignation.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeDesignationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeDesignation table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeDesignationDbEntity aEmployeeDesignation)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeDesignation.Id);
					 vParams.Add("@DesignationId",aEmployeeDesignation.DesignationId);
					 vParams.Add("@EmployeeId",aEmployeeDesignation.EmployeeId);
					 vParams.Add("@EmploymentStatusId",aEmployeeDesignation.EmploymentStatusId);
					 vParams.Add("@JobCategoryId",aEmployeeDesignation.JobCategoryId);
					 vParams.Add("@DepartmentId",aEmployeeDesignation.DepartmentId);
					 vParams.Add("@ContrcatStartDate",aEmployeeDesignation.ContrcatStartDate);
					 vParams.Add("@ContrcatEndDate",aEmployeeDesignation.ContrcatEndDate);
					 vParams.Add("@ContractDetails",aEmployeeDesignation.ContractDetails);
					 vParams.Add("@ActiveFrom",aEmployeeDesignation.ActiveFrom);
					 vParams.Add("@ActiveTo",aEmployeeDesignation.ActiveTo);
					 vParams.Add("@CreatedDateTime",aEmployeeDesignation.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeDesignation.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeDesignation.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeDesignation.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeDesignationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeDesignation table.
		/// </summary>
		public EmployeeDesignationDbEntity GetEmployeeDesignation(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeDesignationDbEntity>("USP_EmployeeDesignationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeDesignation table.
		/// </summary>
		 public IEnumerable<EmployeeDesignationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeDesignationDbEntity>("USP_EmployeeDesignationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the EmployeeDesignation table by a foreign key.
		/// </summary>
		public List<EmployeeDesignationDbEntity> SelectAllByDesignationId(Guid designationId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@DesignationId",designationId);
				 return vConn.Query<EmployeeDesignationDbEntity>("USP_EmployeeDesignationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeDesignation table by a foreign key.
		/// </summary>
		public List<EmployeeDesignationDbEntity> SelectAllByEmployeeId(Guid employeeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmployeeId",employeeId);
				 return vConn.Query<EmployeeDesignationDbEntity>("USP_EmployeeDesignationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeDesignation table by a foreign key.
		/// </summary>
		public List<EmployeeDesignationDbEntity> SelectAllByDepartmentId(Guid? departmentId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@DepartmentId",departmentId);
				 return vConn.Query<EmployeeDesignationDbEntity>("USP_EmployeeDesignationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeDesignation table by a foreign key.
		/// </summary>
		public List<EmployeeDesignationDbEntity> SelectAllByEmploymentStatusId(Guid employmentStatusId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmploymentStatusId",employmentStatusId);
				 return vConn.Query<EmployeeDesignationDbEntity>("USP_EmployeeDesignationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeDesignation table by a foreign key.
		/// </summary>
		public List<EmployeeDesignationDbEntity> SelectAllByJobCategoryId(Guid jobCategoryId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@JobCategoryId",jobCategoryId);
				 return vConn.Query<EmployeeDesignationDbEntity>("USP_EmployeeDesignationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
