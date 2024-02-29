

package com.haatbazar.backend.User.Service;

import com.haatbazar.backend.User.Model.UserRole;
import com.haatbazar.backend.User.Repository.UserRoleRepository;
import com.haatbazar.backend.User.dto.user.ResponseDto;
import com.haatbazar.backend.User.dto.user.UserRoleDto;
import com.haatbazar.backend.exceptions.CustomException;
import java.util.List;
import java.util.Objects;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserRoleService {
    @Autowired
    UserRoleRepository userRoleRepository;

    public UserRoleService() {
    }

    public ResponseDto userRole(UserRoleDto userRoleDto) throws CustomException {
        String roleName = userRoleDto.getRole();
        UserRole existingRole = this.userRoleRepository.findByRole(roleName);
        if (Objects.nonNull(existingRole)) {
            throw new CustomException("Role already exists");
        } else {
            UserRole newRole = new UserRole();
            newRole.setRole(roleName);
            this.userRoleRepository.save(newRole);
            return new ResponseDto("success", "Role created successfully");
        }
    }

    public List<UserRole> getAllUserRoles() {
        return this.userRoleRepository.findAll();
    }
}
