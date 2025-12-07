package com.lchjy.service.impl;

import com.lchjy.entity.NingboCulture;
import com.lchjy.mapper.CultureMapper;
import com.lchjy.service.CultureService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Service
public class CultureServiceImpl implements CultureService {

    @Autowired
    private CultureMapper cultureMapper;

    @Override
    public PageInfo<NingboCulture> list(String keyword, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<NingboCulture> list = cultureMapper.selectList(keyword);
        return new PageInfo<>(list);
    }

    @Override
    public NingboCulture getById(Integer id) {
        return cultureMapper.selectById(id);
    }

    @Override
    public void add(NingboCulture culture) {
        cultureMapper.insert(culture);
    }

    @Override
    public void update(NingboCulture culture) {
        cultureMapper.update(culture);
    }

    @Override
    public void delete(Integer id) {
        cultureMapper.deleteById(id);
    }
}
