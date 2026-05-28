<?php

namespace App\Http\Requests\Admin;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateStaffRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'email' => [
                'required',
                'string',
                'email',
                'max:255',
                Rule::unique('users')->ignore($this->route('staff')),
            ],
            'password' => 'nullable|string|min:8',
            'permissions' => 'nullable|array',
            'permissions.*' => 'string',
        ];
    }

    /**
     * Get the validation messages in Vietnamese.
     */
    public function messages(): array
    {
        return [
            'name.required' => 'Họ và tên nhân sự không được để trống.',
            'name.string' => 'Họ và tên phải là chuỗi ký tự hợp lệ.',
            'name.max' => 'Họ và tên không được vượt quá 255 ký tự.',
            'email.required' => 'Địa chỉ email không được để trống.',
            'email.string' => 'Email phải là chuỗi ký tự hợp lệ.',
            'email.email' => 'Địa chỉ email không đúng định dạng.',
            'email.max' => 'Email không được vượt quá 255 ký tự.',
            'email.unique' => 'Địa chỉ email này đã được sử dụng trên hệ thống.',
            'password.string' => 'Mật khẩu phải là chuỗi ký tự hợp lệ.',
            'password.min' => 'Mật khẩu bảo mật phải chứa ít nhất 8 ký tự.',
            'permissions.array' => 'Danh sách quyền phải ở dạng mảng dữ liệu.',
            'permissions.*.string' => 'Tên quyền hạn phải là chuỗi ký tự hợp lệ.',
        ];
    }
}
