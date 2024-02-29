

package com.haatbazar.backend.User.Repository;

import com.haatbazar.backend.User.Model.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRoleRepository extends JpaRepository<UserRole, Integer> {
    UserRole findByRole(String role);
}
