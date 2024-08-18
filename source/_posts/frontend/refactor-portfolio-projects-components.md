---
title: 拆分與重構 React Component：優化 Projects 頁面組件結構
categories: Frontend
date: 2024-08-17 00:00:00
tags: 
- React
- Typescript
cover: /images/cover/frontend/refactor-portfolio-projects-components.png
---

在我的網頁中 [1chooo.com](https://1chooo.com) 有一個展示我所有作品集的頁面 -- [Hugo's Portfolio](https://1chooo.com/portfolio)，過去我把所有的功能都寫在同一個 component -- [Projects](https://github.com/1chooo/1chooo.com/blob/56584061c5da4c92f25bea1a633b2693f47e0414/src/components/portfolio/projects.tsx) 之中，但是我發現這頁面中的有些元素我會重複使用，因此就造成了 copy-paste programming 的情況，這樣會讓程式碼變得雜亂，也更不容易維護，因此我決定把這個 component 劃分成更小的 components，並且以這篇文章記錄我的修改過程。

首先我們可以先透過頁面的元素來分析我們該如何區分 component

![https://1chooo.com/portfolio](/images/post/frontend/refactor-portfolio-projects-components/projects-demo.png)

我們可以觀察到把這個 component 中的元素分成幾個部分：

1. Filter: 可以用來選擇要顯示的作品類別
2. Select: 一個下拉式選單，也可以用來選擇要顯示的作品類別，是在手機版時的顯示樣貌
3. ProjectList: 用來顯示所有的作品

因此我們可以往這個方向去修改，我們把原本的 `Projects` component 分成三個 components，分別是 `FilterList`, `FilterSelectBox`, `ProjectItem`，這樣我們就可以把這些 components 獨立開來，並且可以更容易地維護。

改寫好的 Source Code 如下：

`filter-list`:

```tsx
import React from 'react';
import { projectTags } from '@/config/portfolio';
import { handleItemClick } from '@/utils/filter-utils';

interface FilterListProps {
  selectedValue: string;
  setSelectedValue: React.Dispatch<React.SetStateAction<string>>;
}

const FilterList: React.FC<FilterListProps> = ({ selectedValue, setSelectedValue }) => (
  <ul className="filter-list">
    {projectTags.map((tag) => (
      <li className="filter-item" key={tag}>
        <button
          className={`filter-btn ${selectedValue === tag ? 'active' : ''}`}
          onClick={() => handleItemClick(tag, setSelectedValue)}
        >
          {tag}
        </button>
      </li>
    ))}
  </ul>
);

export default FilterList;
```

`filter-select-box`:

```tsx
import React from 'react';
import { MdExpandMore } from "react-icons/md";
import { projectTags } from '@/config/portfolio';
import { handleItemClick } from '@/utils/filter-utils';

interface FilterSelectBoxProps {
  selectedValue: string;
  isSelectActive: boolean;
  setIsSelectActive: React.Dispatch<React.SetStateAction<boolean>>;
  setSelectedValue: React.Dispatch<React.SetStateAction<string>>;
}

const FilterSelectBox: React.FC<FilterSelectBoxProps> = ({
  selectedValue,
  isSelectActive,
  setIsSelectActive,
  setSelectedValue,
}) => (
  <div className="filter-select-box">
    <button
      className={`filter-select ${isSelectActive ? 'active' : ''}`}
      onClick={() => setIsSelectActive(!isSelectActive)}
    >
      <div className="select-value">
        {selectedValue || 'Select category'}
      </div>
      <div className="select-icon">
        <MdExpandMore />
      </div>
    </button>
    {isSelectActive && (
      <ul className="select-list">
        {projectTags.map((tag: string) => (
          <li className="select-item" key={tag}>
            <button
              onClick={() => {
                handleItemClick(tag, setSelectedValue);
                setIsSelectActive(false);
              }}
            >
              {tag}
            </button>
          </li>
        ))}
      </ul>
    )}
  </div>
);

export default FilterSelectBox;
```

`project-item`:

```tsx
import React from 'react';
import { LuEye } from "react-icons/lu";
import Image from 'next/image';
import { Project } from '@/config/portfolio';

interface ProjectItemProps {
  project: Project;
}

const ProjectItem: React.FC<ProjectItemProps> = ({ project }) => (
  <li
    className="project-item active"
    data-filter-item
    data-category={project.category.toLowerCase()}
  >
    <a
      href={project.link}
      target="_blank"
      rel="noopener noreferrer"
    >
      <figure className="project-img">
        <div className="project-item-icon-box">
          <LuEye />
        </div>
        <Image
          src={project.imageUrl}
          alt={project.title}
          loading="lazy"
        />
      </figure>
      <h3 className="project-title">{project.title}</h3>
      <p className="project-category">{project.category}</p>
    </a>
  </li>
);

export default ProjectItem;
```

最後我們把這些 components 組合到 `projects`（可見本次修改 [commit](https://github.com/1chooo/1chooo.com/commit/efdbee34c4a8d5f651f537f23f9811eaf4dbbb4d)）：



```tsx
import React, { useState, useEffect } from 'react';
import { projectsData } from '@/config/portfolio';
import { filterCategory } from '@/utils/filter-utils';
import FilterList from './filter-list';
import FilterSelectBox from './filter-select-box';
import ProjectItem from './project-item';

const Projects: React.FC = () => {
  const [selectedValue, setSelectedValue] = useState('All');
  const [isSelectActive, setIsSelectActive] = useState(false);

  useEffect(() => {
    setSelectedValue('All');
  }, []);

  const filteredProjects = filterCategory(selectedValue, projectsData);

  return (
    <section className="projects">
      <FilterList
        selectedValue={selectedValue}
        setSelectedValue={setSelectedValue}
      />
      <FilterSelectBox
        selectedValue={selectedValue}
        isSelectActive={isSelectActive}
        setIsSelectActive={setIsSelectActive}
        setSelectedValue={setSelectedValue}
      />
      <ul className="project-list">
        {filteredProjects.map((project, index) => (
          <ProjectItem project={project} key={index} />
        ))}
      </ul>
    </section>
  );
};

export default Projects;
```

這樣我們就把原本的 `Projects` component 分成三個 components，這樣我們就可以更容易地維護這個 component 了。如果其他頁面需要類似風格的 Item 可以沿用，也可以繼續擴充 Portfolio 頁面的元素，例如加入頁碼功能，這樣如果 project 過多時，就可以分頁顯示，這樣就可以讓頁面更加的乾淨，也能有更好的 component 實踐！