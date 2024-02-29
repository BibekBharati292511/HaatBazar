
package com.haatbazar.backend.User.dto.user;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ChangePassDto {
    private String email;
    private String newPassword;

    public ChangePassDto() {
    }

}
