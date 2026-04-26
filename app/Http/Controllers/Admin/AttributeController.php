<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Attribute;
use App\Models\AttributeValue;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Str;

class AttributeController extends Controller
{
    public function index(Request $request)
    {
        $search = $request->input('search');

        $attributes = Attribute::when($search, function ($query, $search) {
                $query->where('name', 'like', "%{$search}%");
            })
            ->with(['values'])
            ->withCount('values')
            ->orderBy('id', 'desc')
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Admin/Attributes/Index', [
            'attributes' => $attributes,
            'filters' => $request->only(['search'])
        ]);
    }

    public function create()
    {
        return Inertia::render('Admin/Attributes/Form');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'type' => 'required|in:text,select,color',
            'values' => 'nullable|array',
            'values.*' => 'string|max:255'
        ]);
        
        $data['slug'] = Str::slug($data['name']);

        $attribute = Attribute::create($data);

        // Save values
        if (!empty($data['values'])) {
            foreach ($data['values'] as $val) {
                AttributeValue::create([
                    'attribute_id' => $attribute->id,
                    'value' => $val,
                    'code' => Str::slug($val)
                ]);
            }
        }

        return redirect()->route('admin.attributes.index')->with('success', 'Thêm thuộc tính thành công.');
    }

    public function edit(Attribute $attribute)
    {
        $values = $attribute->values;
        return Inertia::render('Admin/Attributes/Form', [
            'attribute' => $attribute,
            'values' => $values
        ]);
    }

    public function update(Request $request, Attribute $attribute)
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'type' => 'required|in:text,select,color',
            'values' => 'nullable|array',
            'values.*' => 'string|max:255'
        ]);
        
        $data['slug'] = Str::slug($data['name']);

        $attribute->update($data);

        // Re-sync values
        if (isset($data['values'])) {
            $existingValues = $attribute->values->pluck('value', 'id')->toArray();
            $newValues = $data['values'];
            
            // Delete values not in new array
            $toDelete = array_diff($existingValues, $newValues);
            if (!empty($toDelete)) {
                AttributeValue::whereIn('id', array_keys($toDelete))->delete();
            }
            
            // Add new values
            $toAdd = array_diff($newValues, $existingValues);
            foreach ($toAdd as $val) {
                AttributeValue::create([
                    'attribute_id' => $attribute->id,
                    'value' => $val,
                    'code' => Str::slug($val)
                ]);
            }
        } else {
            $attribute->values()->delete();
        }

        return redirect()->route('admin.attributes.index')->with('success', 'Cập nhật thuộc tính thành công.');
    }

    public function destroy(Attribute $attribute)
    {
        // For soft delete, simply delete the attribute. Values stay intact if they are not soft deletable, but attribute itself is gone.
        $attribute->delete();
        return redirect()->back()->with('success', 'Xóa thuộc tính thành công.');
    }

    public function trashed(Request $request)
    {
        $search = $request->input('search');
        $attributes = Attribute::onlyTrashed()
            ->when($search, function ($query, $search) {
                $query->where('name', 'like', "%{$search}%");
            })
            ->withCount('values')
            ->orderBy('deleted_at', 'desc')
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Admin/Attributes/Trashed', [
            'attributes' => $attributes,
            'filters' => $request->only(['search'])
        ]);
    }

    public function restore($id)
    {
        $attribute = Attribute::withTrashed()->findOrFail($id);
        $attribute->restore();
        return redirect()->back()->with('success', 'Khôi phục thuộc tính thành công.');
    }

    public function forceDelete($id)
    {
        $attribute = Attribute::withTrashed()->findOrFail($id);
        // Physically delete values
        $attribute->values()->delete();
        $attribute->forceDelete();
        return redirect()->back()->with('success', 'Đã xóa vĩnh viễn thuộc tính.');
    }
}
